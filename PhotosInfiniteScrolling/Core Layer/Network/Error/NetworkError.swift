//
//  NetworkError.swift
//  PhotosInfiniteScrolling
//
//  Created by Charlie Nguyen on 25/06/2021.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case unknown
}
