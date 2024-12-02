//
//  PreferenceModel.swift
//  PintchoukM
//
//  Created by Max Pintchouk on 11/18/24.
//

import Foundation
import SwiftData

@MainActor
@Model
class Preference {
    var locationName: String = ""
    var latString: String = ""
    var longString: String = ""
    var selectedUnit: UnitSystem
    var degreeUnitShowing: Bool = true
    
    init(locationName: String, latString: String, longString: String, selectedUnit: UnitSystem = UnitSystem.imperial, degreeUnitShowing: Bool) {
        self.locationName = locationName
        self.latString = latString
        self.longString = longString
        self.selectedUnit = selectedUnit
        self.degreeUnitShowing = degreeUnitShowing
    }
}

extension Preference {
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Preference.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        container.mainContext.insert(Preference(locationName: "Dublin", latString: "53.33880", longString: "-6.2551", selectedUnit: .metric, degreeUnitShowing: true))
        return container
    }
}
