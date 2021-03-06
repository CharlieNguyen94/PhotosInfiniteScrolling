//
//  PhotoDetailViewModel.swift
//  PhotosInfiniteScrolling
//
//  Created by Charlie Nguyen on 25/06/2021.
//

import RxSwift
import RxRelay

/// View model interface that is visible to the PhotoDetailViewController
protocol PhotoDetailViewModel: AnyObject {
    // Input
    var viewDidLoad: PublishRelay<Void> { get }
    
    // Output
    var isLoading: BehaviorRelay<Bool> { get }
    var imageRetrievedError: PublishRelay<Void> { get }
    var imageRetrievedSucceess: PublishRelay<UIImage> { get }
    var description: PublishRelay<String> { get }
}

final class PhotoDetailViewModelImplementation: PhotoDetailViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    
    // MARK: - Output
    let isLoading = BehaviorRelay<Bool>(value: false)
    let imageRetrievedError = PublishRelay<Void>()
    let imageRetrievedSucceess = PublishRelay<UIImage>()
    let description = PublishRelay<String>()
    
    // MARK: - Private Properties
    private let photoService: UnsplashPhotoService
    private let photoLoadingService: DataLoadingService
    private let dataToImageService: DataToImageConversionService
    private let coordinator: PhotoDetailCoordinator
    
    private let disposeBag = DisposeBag()
    private let unsplashPhoto = PublishRelay<UnsplashPhoto>()
    private let photoId: String
    
    // MARK: - Initialization
    init(photoService: UnsplashPhotoService,
         photoLoadingService: DataLoadingService,
         dataToImageService: DataToImageConversionService,
         coordinator: PhotoDetailCoordinator,
         photoId: String) {
        
        self.photoService = photoService
        self.photoLoadingService = photoLoadingService
        self.dataToImageService = dataToImageService
        self.coordinator = coordinator
        
        self.photoId = photoId
        
        bindOnViewDidLoad()
        bindOnPhotoRetrieval()
        
    }
    
    private func bindOnViewDidLoad() {
        viewDidLoad
            .do(onNext: { [unowned self] _ in
                self.getPhoto()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindOnPhotoRetrieval() {
        // Bind to description
        unsplashPhoto
            .flatMap({ (unsplashPhoto) -> Observable<String?> in
                var description: String?
                
                if let photoDescription = unsplashPhoto.description {
                    description = photoDescription
                } else if let alternativeDescription = unsplashPhoto.altDescription {
                    description = alternativeDescription
                }
                
                return Observable.just(description)
            })
            .compactMap { $0 }
            .bind(to: description)
            .disposed(by: disposeBag)
        
        // Bind to image
        unsplashPhoto
            .flatMap { [weak self] (photo) -> Observable<(Data?, Error?)> in
                guard let self = self else { return .empty() }
                
                if let photoURL = photo.urls?.regular {
                    return self.photoLoadingService
                        .loadData(for: photoURL)
                        .observeOn(
                            ConcurrentDispatchQueueScheduler(qos: .background)
                        )
                } else {
                    self.imageRetrievedError.accept(())
                    return Observable.of((nil, NetworkError.decodingFailed))
                    
                }
            }
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(false)
            })
            .map({ [weak self] (data, error) -> (UIImage?, Error?) in
                if let imageData = data,
                   let image = self?.dataToImageService.getImage(from: imageData) {
                    return (image, nil)
                } else {
                    self?.imageRetrievedError.accept(())
                    return (nil, NetworkError.decodingFailed)
                }
            })
            .compactMap { $0.0 }
            .bind(to: imageRetrievedSucceess)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Service Methods
    private func getPhoto() {
        isLoading.accept(true)
        
        photoService.getPhoto(id: photoId)
            .compactMap({ [weak self] (unsplashPhoto, error) in
                guard let photo = unsplashPhoto, error == nil else {
                    self?.imageRetrievedError.accept(())
                    return nil
                }
                return photo
            })
            .bind(to: unsplashPhoto)
            .disposed(by: disposeBag)
        
        
    }
}
