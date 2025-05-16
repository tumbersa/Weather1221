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

    @Published var loadingState: LoadingState = .initial
    @Published var forecastEntities: [ForecastDayEntity] = []

    init(networkManager: INetworkManager) {
        self.networkManager = networkManager

        getForecastData()
    }

    func getForecastData() {
        let url = Endpoint.forecast
            .queryItems([
                "q": "Voronezh",
                "days": "5"
            ])
            .url
        networkManager.getData(with: url, ForecastEntry.self)
            .receive(on: DispatchQueue.main)
            .map { [weak self] entry -> [ForecastDayEntity] in
                self?.map(entry) ?? []
            }
            .sink { [weak self] completion in
                switch completion {
                    case let .failure(error):
#if DEBUG
                        print(error)
#endif
                        self?.loadingState = .failure
                    case .finished:
                        break
                }
            } receiveValue: { [weak self] entities in
                guard let self else { return }
                forecastEntities = entities
                loadingState = .success
            }
            .store(in: &cancellables)

    }
}

private extension ForecastListViewModel {
    func map(_ entry: ForecastEntry) -> [ForecastDayEntity] {
        entry.forecast.forecastday.compactMap { forecastday -> ForecastDayEntity? in
            guard let iconBaseUrl = forecastday.day.condition?.icon,
                  let text = forecastday.day.condition?.text else {
                return nil
            }
            let iconUrl = Endpoint().base("https:" + iconBaseUrl).url
            return ForecastDayEntity(
                text: text,
                iconUrl: iconUrl,
                tempC: forecastday.day.avgtempC,
                windKph: forecastday.day.maxwindKph,
                humidity: forecastday.day.avghumidity
            )
        }
    }
}
