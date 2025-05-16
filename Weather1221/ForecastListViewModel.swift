//
//  ForecastListViewModel.swift
//  Weather1221
//
//  Created by Глеб Капустин on 16.05.2025.
//

import Foundation
import Combine

final class ForecastListViewModel: ObservableObject {

    private let networkManager: INetworkManager
    private var cancellables: Set<AnyCancellable> = []

    @Published var forecastAll: [ForecastEntry.Forecastday] = []

    init(networkManager: INetworkManager) {
        self.networkManager = networkManager
    }

    func getForecastData() {
        let url = Endpoint.forecast
            .queryItems([
                "q": "Voronezh",
                "days": "5",
                "aqi": "no",
                "alerts": "no"
            ])
            .url
        networkManager.getData(with: url, ForecastEntry.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case let .failure(error):
                        print(error)
                    case .finished:
                        break
                }
            } receiveValue: { [weak self] entry in
                guard let self else { return }

                print(entry.forecast)
                forecastAll = entry.forecast.forecastday

            }
            .store(in: &cancellables)

    }
}
