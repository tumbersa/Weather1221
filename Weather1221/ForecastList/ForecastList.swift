//
//  ForecastList.swift
//  Weather1221
//
//  Created by Глеб Капустин on 16.05.2025.
//

import SwiftUI

struct ForecastList: View {
    @StateObject private var viewModel: ForecastListViewModel = .init(networkManager: NetworkManager())

    var body: some View {
        switch viewModel.loadingState {
            case .initial, .loading, .failure:
                ProgressView()
            case .success:
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.forecastEntities) { forecastEntity in
                            VStack(alignment: .leading) {
                                HStack {
                                    AsyncImage(url: forecastEntity.iconUrl) { result in
                                        result.image?.resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                    Text(forecastEntity.text)
                                }
                                Text("tempC: \(forecastEntity.tempC)")
                                Text("windKph: \(forecastEntity.windKph)")
                                Text("humidity: \(forecastEntity.humidity)")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical)
                        }
                    }
                    .padding()
                }
        }
    }
}

