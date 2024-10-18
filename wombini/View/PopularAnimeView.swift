import SwiftUI

struct PopularAnimeView: View {
    @ObservedObject var animeController = AnimeController()
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedSeason = getCurrentSeason()  // Dynamically set based on current season
    @State private var searchText = ""  // State for search text
    
    let seasons = ["winter", "spring", "summer", "fall"]

    // Computed property to filter anime list based on search query
    var filteredAnimeList: [Anime] {
        if searchText.isEmpty {
            return animeController.animeList
        } else {
            return animeController.animeList.filter { anime in
                anime.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Search bar for anime search
                TextField("Search Anime", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                HStack {
                    Picker("Year", selection: $selectedYear) {
                        ForEach((2000...Calendar.current.component(.year, from: Date())), id: \.self) { year in
                            Text("\(year)")  // Correct formatting of year (no extra commas)
                                .tag(year)
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

                // Scroll view for anime grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredAnimeList) { anime in
                            NavigationLink(destination: AnimeDetailView(anime: anime)) {
                                AnimeCardView(anime: anime)  // Use consistent card style
                            }
                            .buttonStyle(PlainButtonStyle())  // Prevent default button styling
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Popular Anime by Season")
            .onAppear {
                // Automatically fetch data when the view appears
                animeController.fetchPopularAnimeBySeason(year: selectedYear, season: selectedSeason)
            }
            // Fetch data automatically when the user changes the year or season
            .onChange(of: selectedYear) { newYear in
                animeController.fetchPopularAnimeBySeason(year: newYear, season: selectedSeason)
            }
            .onChange(of: selectedSeason) { newSeason in
                animeController.fetchPopularAnimeBySeason(year: selectedYear, season: newSeason)
            }
        }
    }
}

// A helper function to determine the current season based on the month
func getCurrentSeason() -> String {
    let month = Calendar.current.component(.month, from: Date())
    switch month {
    case 12, 1, 2:
        return "winter"
    case 3, 4, 5:
        return "spring"
    case 6, 7, 8:
        return "summer"
    case 9, 10, 11:
        return "fall"
    default:
        return "spring"  // Default case, though this shouldn't happen
    }
}

// AnimeCardView for consistent style and layout
struct AnimeCardView: View {
    let anime: Anime

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: anime.images.jpg.image_url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 220)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: 150, height: 220)
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
        .frame(width: 150, height: 280)
    }
}
