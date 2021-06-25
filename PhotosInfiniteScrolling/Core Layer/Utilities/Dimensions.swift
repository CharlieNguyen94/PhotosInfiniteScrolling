//
//  Dimensions.swift
//  PhotosInfiniteScrolling
//
//  Created by Charlie Nguyen on 25/06/2021.
//

import UIKit

struct Dimensions {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    static let photoItemSize = CGSize(
        width: Dimensions.screenWidth * 0.45,
        height: Dimensions.screenHeight * 0.45)
}
