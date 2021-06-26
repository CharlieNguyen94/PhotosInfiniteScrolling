//
//  PhotoDetailCoordinator.swift
//  PhotosInfiniteScrolling
//
//  Created by Charlie Nguyen on 25/06/2021.
//

import UIKit

protocol PhotoDetailCoordinator: AnyObject {}
    
class PhotoDetailCoordinatorImplementation: Coordinator {
    unowned let navigationController: UINavigationController
    let photoId: String
    
    init(navigationController: UINavigationController, photoId: String) {
        self.navigationController = navigationController
        self.photoId = photoId
    }
    
    func start() {
        let photoDetailViewController = PhotoDetailViewController()
        let photoDetailViewModel = PhotoDetailViewModelImplementation(
            photoService: UnsplashPhotosServiceImplementation(),
            photoLoadingService: DataLoadingServiceImplementation(),
            dataToImageService: DataToImageConversionServiceImplementation(),
            coordinator: self,
            photoId: photoId)
        
        photoDetailViewController.viewModel = photoDetailViewModel
        navigationController.pushViewController(photoDetailViewController,
                                                animated: true)
        
    }
}

extension PhotoDetailCoordinatorImplementation: PhotoDetailCoordinator {}
