//
//  NetworkManager.swift
//  Weather1221
//
//  Created by Глеб Капустин on 16.05.2025.
//

import Foundation
import Combine

// MARK: - Network protocol
protocol INetworkManager: AnyObject {
    func getData<T>(with url: URL, _ type: T.Type) -> AnyPublisher<T, Error> where T: Decodable
}

final class NetworkManager: INetworkManager {
    private let decoder = JSONDecoder()

    func getData<T>(with url: URL, _ type: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        let request = URLRequest(url: url)
        return Future {
            try await self.asyncRequest(from: request, type, decoder: self.decoder)
        }
        .eraseToAnyPublisher()
    }
}

extension NetworkManager {
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else { throw URLError(.cancelled) }

        switch response.statusCode {
            case ~200..<300:
                break
            case 401:
                throw NetworkError.unauthorized
            case ~500..<600:
                throw NetworkError.serverError
            default: throw NetworkError.undefinedError
        }

        if output.data.isEmpty {
            throw NetworkError.emptyResponse
        } else {
            return output.data
        }
    }

    //MARK: - Универсальный блок для асинхронных запросов
    /// - request: URLRequest. Сформированный и настроеный вне запрос
    /// - type: ожидаемый тип данных для декодирования
    private func asyncRequest<T: Decodable>(from request: URLRequest, _ type: T.Type, decoder: JSONDecoder) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        return try decoder.decode(type, from: handleOutput(output: (data, response)))
    }
}
