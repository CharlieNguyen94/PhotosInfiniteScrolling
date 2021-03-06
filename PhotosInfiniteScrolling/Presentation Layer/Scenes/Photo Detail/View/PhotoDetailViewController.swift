//
//  PhotoDetailViewController.swift
//  PhotosInfiniteScrolling
//
//  Created by Charlie Nguyen on 25/06/2021.
//

import UIKit
import RxSwift

class PhotoDetailViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindImageView()
        bindDescriptionLabel()
        bindActivityIndicator()
        
        viewModel.viewDidLoad.accept(())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setupNavigationItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.center = photoImageView.center
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel: PhotoDetailViewModel!
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont(name: "ArialMT", size: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
}

// MARK: - Binding
extension PhotoDetailViewController {
    func bindImageView() {
        viewModel.imageRetrievedSucceess
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
//                self?.photoImageView.alpha = 0
//                UIView.animate(withDuration: 0.25) {
//                    self?.photoImageView.alpha = 1.0
//                }
                self?.photoImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                UIView.animate(withDuration: 0.25) {
                    self?.photoImageView.transform = .identity
                }
            })
            .bind(to: photoImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.imageRetrievedError
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.photoImageView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    self?.photoImageView.alpha = 1.0
                    self?.photoImageView.backgroundColor = .black
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func bindDescriptionLabel() {
        viewModel.description
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.descriptionLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                UIView.animate(withDuration: 0.25) {
                    self?.descriptionLabel.transform = .identity
                }
            })
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindActivityIndicator() {
        viewModel.isLoading
            .observeOn(MainScheduler.instance)
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Setup
extension PhotoDetailViewController {
    private func setupUI() {
        if #available(iOS 13, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(photoImageView)
        self.view.addSubview(descriptionLabel)
        photoImageView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            photoImageView.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            photoImageView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoImageView.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            photoImageView.heightAnchor
                .constraint(equalToConstant: Dimensions.screenHeight * 0.3)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor
                .constraint(equalTo: self.view.leftAnchor,
                            constant: 20),
            descriptionLabel.topAnchor
                .constraint(equalTo: self.photoImageView.bottomAnchor,
                            constant: 20),
            descriptionLabel.rightAnchor
                .constraint(equalTo: self.view.rightAnchor,
                            constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = "Photo Detail"
    }
}
