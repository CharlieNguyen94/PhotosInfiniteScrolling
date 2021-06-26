//
//  DataToImageConversionService.swift
//  PhotosInfiniteScrolling
//
//  Created by Charlie Nguyen on 25/06/2021.
//

import UIKit

protocol DataToImageConversionService: AnyObject {
    func getImage(from data: Data) -> UIImage?
}

class DataToImageConversionServiceImplementation: DataToImageConversionService {
    func getImage(from data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
