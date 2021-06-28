//
//  PhotosInfiniteScrollingTests.swift
//  PhotosInfiniteScrollingTests
//
//  Created by Charlie Nguyen on 25/06/2021.
//

import XCTest
import RxSwift
@testable import PhotosInfiniteScrolling

class PhotosViewModelTests: XCTestCase {

    // MARK: - System Under Test
    private var disposeBag: DisposeBag!
    private var sut: PhotosViewModelImplementation!
    private var navigationController: UINavigationController!
    
    // MARK: - Set Up & Tear Down
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        navigationController = UINavigationController()
        sut = PhotosViewModelImplementation(
            photoService: UnsplashPhotosServiceImplementation(),
            photoLoadingService: DataLoadingServiceImplementation(),
            dataToImageService: DataToImageConversionServiceImplementation(),
            coordinator: PhotosCoordinatorImplementation(navigationController: navigationController)
        )
    }
    
    override func tearDown() {
        disposeBag = nil
        sut = nil
        navigationController = nil
        super.tearDown()
    }
}
