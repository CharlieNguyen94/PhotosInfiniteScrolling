//
//  UnsplashPhoto.swift
//  PhotosInfiniteScrolling
//
//  Created by Charlie Nguyen on 25/06/2021.
//

import Foundation

struct UnsplashPhoto: Codable {
    let id: String?
    let description: String?
    let altDescription: String?
    let urls: Urls?
    
    enum CodingKeys: String, CodingKey {
        case id, description
        case altDescription = "alt_description"
        case urls
    }
}

struct Urls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}
