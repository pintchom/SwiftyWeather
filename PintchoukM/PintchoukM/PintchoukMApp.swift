//
//  PintchoukMApp.swift
//  PintchoukM
//
//  Created by Max Pintchouk on 11/18/24.
//

import SwiftUI

@main
struct PintchoukMApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView()
                .environment(WeatherViewModel())
                .modelContainer(for: Preference.self)
        }
    }
}
