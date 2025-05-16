//
//  Endpoint.swift
//  Weather1221
//
//  Created by Глеб Капустин on 16.05.2025.
//

import Foundation


struct Endpoint {
    private var components: URLComponents

    init() {
        self.components = URLComponents()
    }

    func base(_ baseURL: String) -> Endpoint {
        var copy = self
        let url = URL(string: baseURL)
        copy.components.path =  url?.path ?? ""
        copy.components.scheme = url?.scheme
        copy.components.host = url?.host
        return copy
    }

    func path(_ path: String) -> Endpoint {
        var copy = self
        copy.components.path += path
        return copy
    }

    func queryItem(name: String, value: String?) -> Endpoint {
        var copy = self
        var queryItems = copy.components.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value))
        copy.components.queryItems = queryItems
        return copy
    }

    func queryItems(_ items: [String: String?]) -> Endpoint {
        var copy = self
        var queryItems = copy.components.queryItems ?? []
        items.forEach { key, value in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        copy.components.queryItems = queryItems
        return copy
    }

}

extension Endpoint {
    var url: URL {
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
}

extension Endpoint {
    private enum ConstantsKey {
        static let key = "key"
    }

    static var forecast: Self {
        Endpoint()
            .base(Constants.Weather.baseUrl)
            .path(Constants.Weather.forecastPath)
            .queryItems([ConstantsKey.key: PrivateConstants.Weather.apiKey])
    }
}

