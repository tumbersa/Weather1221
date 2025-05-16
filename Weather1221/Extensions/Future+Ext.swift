//
//  Future+Ext.swift
//  Weather1221
//
//  Created by Глеб Капустин on 16.05.2025.
//

import Combine

extension Future where Failure == Error {
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}

