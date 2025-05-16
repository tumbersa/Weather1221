//
//  NetworkError.swift
//  Weather1221
//
//  Created by Глеб Капустин on 16.05.2025.
//

import Foundation

enum NetworkError: Error {
    case unauthorized
    case emptyResponse
    case serverError
    case undefinedError
}
