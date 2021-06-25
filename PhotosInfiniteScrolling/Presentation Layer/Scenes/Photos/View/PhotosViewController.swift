//
//  PhotosViewController.swift
//  PhotosInfiniteScrolling
//
//  Created by Charlie Nguyen on 25/06/2021.
//

import UIKit

import RxSwift
import RxCocoa

class PhotosViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        
        
        viewModel.viewDidLoad.accept(())
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        setupNavigationItem()
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var viewModel: PhotosViewModel!
    private var cachedImages: [Int: UIImage] = [:]
    
    lazy var photosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
        
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    lazy var bottomActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
}

// MARK: - Binding
extension PhotosViewController {
    private func bindCollectionView() {
        /// Bind unsplash photos to the collection view items
        viewModel.unsplashPhotos
            .bind(to: photosCollectionView.rx.items(
                    cellIdentifier: PhotoCell.reuseIdentifier,
                    cellType: PhotoCell.self)) { _, _, _ in }
            .disposed(by: disposeBag)
        
        /// Prepare cell to be displayed. Launch photo loading operation if no cached image is found
        photosCollectionView.rx.willDisplayCell
            .filter { $0.cell.isKind(of: PhotoCell.self) }
            .map { ($0.cell as! PhotoCell, $0.at.item) }
            .do(onNext: { (cell, index) in
                cell.imageView.image = nil
            })
            .subscribe(onNext: { [weak self] (cell, index) in
                if let cachedImage = self?.cachedImages[index] {
                    print("Using cached images for \(index)")
                    cell.imageView.image = cachedImage
                } else {
                    cell.activityIndicator.startAnimating()
                    self?.viewModel
                        .willDisplayCellAtIndex
                        .accept(index)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Setup
extension PhotosViewController {
    private func setupUI() {
        if #available(iOS 13, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(photosCollectionView)
        self.view.addSubview(bottomActivityIndicator)
        
        bottomConstraint = photosCollectionView.bottomAnchor
            .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            photosCollectionView.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            photosCollectionView.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            photosCollectionView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            bottomConstraint!
        ])
        
        NSLayoutConstraint.activate([
            bottomActivityIndicator.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            bottomActivityIndicator.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomActivityIndicator.widthAnchor
                .constraint(equalToConstant: 44),
            bottomActivityIndicator.heightAnchor
                .constraint(equalToConstant: 44)
        ])
        
        
    }
    
    /// Change photoCollectionView's bottom constraint with a subtle animation
    private func updateConstraintForMode(loadingMorePhotos: Bool) {
        self.bottomConstraint?.constant = loadingMorePhotos ? -20 : 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = "Unsplash Photos"
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = Dimensions.photoItemSize
        let numberOfCellsInRow = floor(Dimensions.screenWidth / Dimensions.photoItemSize.width)
        let inset = (Dimensions.screenWidth - (numberOfCellsInRow * Dimensions.photoItemSize.width)) / (numberOfCellsInRow + 1)
        layout.sectionInset = .init(top: inset,
                                    left: inset,
                                    bottom: inset,
                                    right: inset)
        
        return layout
    }
}
