//
//  ContentView.swift
//  PintchoukM
//
//  Created by Max Pintchouk on 11/18/24.
//

import SwiftUI
import SwiftData

struct WeatherView: View {
    @Environment(\.modelContext) var modelContext
    @Query var preferences: [Preference]
    @EnvironmentObject var weatherModel: WeatherViewModel
    @State private var imageName: String = ""
    @State private var weatherDescription: String = ""
    @State private var presentSheet: Bool = false
    @State private var tempMark: String = "F"
    @State private var speedMark: String = "mph"
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.cyan.opacity(0.75))
                    .ignoresSafeArea()

                VStack {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.multicolor)
                    Text(weatherDescription)
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    Text("\(Int(weatherModel.temperature.rounded()))°\(tempMark)")
                        .font(.system(size: 150, weight: .light, design: .default))
                        .foregroundStyle(.white)
                    Text("Wind \(Int(weatherModel.windspeed.rounded()))\(speedMark) - Feels Like \(Int(weatherModel.feelsLike.rounded()))°\(tempMark)")
                        .font(.title2)
                        .padding(.bottom)
                        .foregroundStyle(.white)
                    if !weatherModel.date.isEmpty {
                        List(0..<7) { i in
                            HStack {
                                Image(systemName: weatherModel.getWeatherIcon(for: weatherModel.dailyWeatherCode[i]))
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                Text(getWeekday(value: i))
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("\(Int(weatherModel.dailyLowTemp[i].rounded()))°\(tempMark)  /")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                Text("\(Int(weatherModel.dailyHighTemp[i].rounded()))°\(tempMark)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            .listRowBackground(Color.clear)

                        }
                        .listStyle(.plain)
                        .frame(width: 400)
                        
                    }
                }
                .onAppear {
                    Task {
                        await runGetData()
                    }
                }
                .onChange(of: preferences) {
                    Task {
                        await runGetData()
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            presentSheet.toggle()
                        } label: {
                            Image(systemName: "gear")
                                .foregroundStyle(.white)
                        }

                    }
                }
                .fullScreenCover(isPresented: $presentSheet) {
                    PreferenceView()
                }
            }
        }
    }
    func getWeekday(value: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: value, to: Date.now)!
        let dayNumber = Calendar.current.component(.weekday, from: date)
        return Calendar.current.weekdaySymbols[dayNumber-1]
    }
    func runGetData() async {
        if !preferences.isEmpty {
            weatherModel.urlString =  "https://api.open-meteo.com/v1/forecast?latitude=\(preferences[0].latString)&longitude=\(preferences[0].latString)&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&hourly=uv_index&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum&temperature_unit=\(preferences[0].selectedUnit == .metric ? "celsius" : "fahrenheit")&wind_speed_unit=\(preferences[0].selectedUnit == .metric ? "kmh" : "mph")&precipitation_unit=inch&timezone=auto"
        }
        speedMark = preferences[0].selectedUnit == .metric ? "kmh" : "mph"
        tempMark = preferences[0].selectedUnit == .metric ? "C" : "F"
        if preferences[0].degreeUnitShowing == false {
            tempMark = ""
        }
        await weatherModel.getData()
        imageName = weatherModel.getWeatherIcon(for: weatherModel.weatherCode)
        weatherDescription = weatherModel.getWeatherDescription(for: weatherModel.weatherCode)
    }
}

#Preview {
    NavigationStack {
        WeatherView()
    }
}
