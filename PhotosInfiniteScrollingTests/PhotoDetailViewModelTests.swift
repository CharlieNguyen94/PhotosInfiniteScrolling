//
//  PhotoDetailViewModelTests.swift
//  PhotosViewModelTests
//
//  Created by Charlie Nguyen on 28/06/2021.
//

import XCTest
import RxSwift

@testable import PhotosInfiniteScrolling

// Unit Testing For PhotoDetailViewModel with RxSwift

class PhotoDetailViewModelTests: XCTestCase {

    // MARK: - System Under Test
    private var disposeBag: DisposeBag!
    private var sut: PhotoDetailViewModel!
    private var navigationController: UINavigationController!
    
    // MARK: - Set Up & Tear Down
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        navigationController = UINavigationController()
        sut = PhotoDetailViewModelImplementation(
            photoService: UnsplashPhotosServiceImplementation(),
            photoLoadingService: DataLoadingServiceImplementation(),
            dataToImageService: DataToImageConversionServiceImplementation(),
            coordinator: PhotoDetailCoordinatorImplementation(
                navigationController: navigationController,
                photoId: "C389V--ZZrQ"),
            photoId: "C389V--ZZrQ")
    }
    
    override func tearDown() {
        disposeBag = nil
        navigationController = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - View Model Tests
    func testWhenViewDidLoad_TriesToLoadData() {
        let expectation = XCTestExpectation(description: "Load image data")
        
        sut.viewDidLoad.accept(())
        
        // Initial Mock Data
        sut.imageRetrievedSucceess
            .subscribe(onNext: { (image) in
                XCTAssertNotNil(image)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.imageRetrievedError
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWhenInvalidPhotoId_imageRetrievedError() {
        let expectation = XCTestExpectation(description: "imageRetrievedError")
        
        sut = PhotoDetailViewModelImplementation(
            photoService: UnsplashPhotosServiceImplementation(),
            photoLoadingService: DataLoadingServiceImplementation(),
            dataToImageService: DataToImageConversionServiceImplementation(),
            coordinator: PhotoDetailCoordinatorImplementation(
                navigationController: navigationController,
                photoId: ""),
            photoId: "")
        
        sut.viewDidLoad.accept(())
        
        sut.imageRetrievedError
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWhenViewDidLoad_triesToLoadDescription() {
        let expectation = XCTestExpectation(description: "Load description data")
        
        sut.viewDidLoad.accept(())
        
        // Initial Mock Data
        sut.description
            .subscribe(onNext: { (description) in
                XCTAssertNotNil(description)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
    
        wait(for: [expectation], timeout: 5.0)
    }
}
