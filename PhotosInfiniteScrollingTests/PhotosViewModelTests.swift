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
    
    // MARK: - View Model Tests
    func testWhenWillDisplayCellTriesToLoadData() {
        
        let expectation = XCTestExpectation(description: "Load image data")
        
        // Initial Mock Data
        sut.unsplashPhotos.accept(
            [
                UnsplashPhoto.init(id: "",
                                   description: "",
                                   altDescription: "",
                                   urls: Urls(
                                    raw: "https://unsplash.com/photos/wxZJ-V6DPKc",
                                    full: "https://unsplash.com/photos/wxZJ-V6DPKc",
                                    regular: "https://unsplash.com/photos/wxZJ-V6DPKc",
                                    small: "https://unsplash.com/photos/wxZJ-V6DPKc",
                                    thumb: "https://unsplash.com/photos/wxZJ-V6DPKc")
                )
            ]
        )
        
        sut.willDisplayCellAtIndex
            .accept(0)
        
        sut.imageRetrievedError
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (index) in
                XCTAssertEqual(index, 0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.imageRetrievedSuccess
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (image, index) in
                XCTAssertNotNil(image)
                XCTAssertEqual(index, 0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
