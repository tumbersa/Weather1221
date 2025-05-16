//
//  ForecastDayEntity.swift
//  Weather1221
//
//  Created by Глеб Капустин on 16.05.2025.
//

import Foundation

struct ForecastDayEntity: Identifiable {
    let id = UUID()

    let text: String
    let iconUrl: URL
    let tempC: Double
    let windKph: Double
    let humidity: Double
}
