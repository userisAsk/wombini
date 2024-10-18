import SwiftUI

struct ScheduleView: View {
    @ObservedObject var animeController = AnimeController()
    @State private var weeklyAnime: [Anime] = []
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            Text("Schedule de la semaine")
                .font(.largeTitle)
                .padding()
            
            DatePicker(
                "Sélectionner une date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(weeklyAnime) { anime in
                        VStack {
                            AsyncImage(url: URL(string: anime.images.jpg.image_url)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 100, height: 150)
                            .cornerRadius(8)
                            
                            Text(anime.title)
                                .font(.headline)
                            
                            Text("Sortie: \(anime.releaseDate)")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchAnimeForSelectedDate()
        }
        .onChange(of: selectedDate, perform: { _ in
            fetchAnimeForSelectedDate()
        })
    }

    // Fetch anime based on selected date
    func fetchAnimeForSelectedDate() {
        let dayOfWeek = Calendar.current.component(.weekday, from: selectedDate)
        fetchAnimeForDay(dayOfWeek)
    }

    func fetchAnimeForDay(_ dayOfWeek: Int) {
        var dayString: String
        switch dayOfWeek {
        case 1: dayString = "sunday"
        case 2: dayString = "monday"
        case 3: dayString = "tuesday"
        case 4: dayString = "wednesday"
        case 5: dayString = "thursday"
        case 6: dayString = "friday"
        case 7: dayString = "saturday"
        default: dayString = "monday"
        }
        
        let urlString = "https://api.jikan.moe/v4/schedules/\(dayString)"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(AnimeListResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.weeklyAnime = response.animes
                        }
                    } catch {
                        print("Error decoding schedule data: \(error)")
                    }
                }
            }.resume()
        }
    }
}
