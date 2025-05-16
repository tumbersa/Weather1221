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
        Text("")
            .onAppear {
                viewModel.getForecastData()
            }
    }
}

