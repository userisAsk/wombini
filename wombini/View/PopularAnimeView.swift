import SwiftUI

struct PopularAnimeView: View {
    @ObservedObject var animeController = AnimeController()
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedSeason = "spring"
    
    let seasons = ["winter", "spring", "summer", "fall"]

    var body: some View {
        VStack {
            HStack {
                Picker("Year", selection: $selectedYear) {
                    ForEach((2000...Calendar.current.component(.year, from: Date())), id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Picker("Season", selection: $selectedSeason) {
                    ForEach(seasons, id: \.self) { season in
                        Text(season.capitalized).tag(season)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()

            Button("Fetch Popular Anime") {
                animeController.fetchPopularAnimeBySeason(year: selectedYear, season: selectedSeason)
            }
            .padding()

            ScrollView {
                AnimeGridView(animeList: animeController.animeList)
                    .padding()
            }
        }
        .navigationTitle("Popular Anime by Season")
    }
}
