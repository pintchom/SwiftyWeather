//
//  PreferenceView.swift
//  PintchoukM
//
//  Created by Max Pintchouk on 11/18/24.
//

import SwiftUI
import SwiftData

struct PreferenceView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var preferences: [Preference]
    @State private var locationName: String = ""
    @State private var latString: String = ""
    @State private var longString: String = ""
    @State private var selectedUnit: UnitSystem = .imperial
    @State private var degreeUnitShowing: Bool = true
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    TextField("location", text: $locationName)
                        .textFieldStyle(.roundedBorder)
                        .font(.title)
                        .padding(.bottom)
                    Text("Latitude")
                        .fontWeight(.bold)
                    TextField("latitude", text: $latString)
                        .textFieldStyle(.roundedBorder)
                    Text("Longitude")
                        .fontWeight(.bold)
                    TextField("longitude", text: $longString)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom)
                }
                
                HStack {
                    Text("Units:")
                        .fontWeight(.bold)
                    Spacer()
                    Picker(selection: $selectedUnit, label: Text("\(selectedUnit.rawValue)")) {
                        Text(UnitSystem.imperial.rawValue).tag(UnitSystem.imperial)
                        Text(UnitSystem.metric.rawValue).tag(UnitSystem.metric)
                    }
                    
                }
                Toggle(isOn: $degreeUnitShowing) {
                    Text("Show F/C after temp value:")
                        .bold()
                        .font(.title2)
                }
                Text("42°\(degreeUnitShowing ? "\(selectedUnit == .imperial ? "F" : "C")" : "")")
                    .font(.system(size: 150, weight: .light, design: .default))
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if preferences.isEmpty {
                modelContext.insert(Preference(locationName: "", latString: "", longString: "", selectedUnit: .imperial, degreeUnitShowing: true))
            } else {
                locationName = preferences[0].locationName
                latString = preferences[0].latString
                longString = preferences[0].longString
                degreeUnitShowing = preferences[0].degreeUnitShowing
                selectedUnit = preferences[0].selectedUnit
            }
        }
    }
    func save() {
        for preference in preferences {
            modelContext.delete(preference)
        }
        modelContext.insert(Preference(locationName: locationName, latString: latString, longString: longString, selectedUnit: selectedUnit, degreeUnitShowing: degreeUnitShowing))
    }
}

#Preview {
    PreferenceView()
}
