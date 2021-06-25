//
//  PhotosCoordinator.swift
//  PhotosInfiniteScrolling
//
//  Created by Charlie Nguyen on 25/06/2021.
//

import UIKit

protocol PhotosCoordinator: AnyObject {
    func pushToPhotoDetail(with photoId: String)
}

class PhotosCoordinatorImplementation: Coordinator {
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let photosViewController = PhotosViewController()
        let photosViewModel = PhotosViewModelImplementation(
            photoService: UnsplashPhotosServiceImplementation(),
            photoLoadingService: DataLoadingServiceImplementation(),
            dataToImageService: DataToImageConversionServiceImplementation(),
            coordinator: self
        )
        photosViewController.viewModel = photosViewModel
        
        navigationController.pushViewController(photosViewController, animated: true)
    }
}

extension PhotosCoordinatorImplementation: PhotosCoordinator {
    
    func pushToPhotoDetail(with photoId: String) {
        let photoDetailCoordinator = PhotoDetailCoordinatorImplementation(
            navigationController: navigationController,
            photoId: photoId
        )
        
        coordinate(to: photoDetailCoordinator)
    }
}
