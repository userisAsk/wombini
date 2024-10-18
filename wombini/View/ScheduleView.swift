import SwiftUI

struct ScheduleView: View {
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
                            Image(anime.images.jpg.image_url)
                                .resizable()
                                .frame(width: 100, height: 150)
                                .cornerRadius(8)
                            
                            Text(anime.title)
                                .font(.headline)
                            
                            // Affiche directement la chaîne de caractères `releaseDate`
                            Text("Sortie: \(anime.releaseDate)")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchWeeklyAnime()
        }
    }
    
    func fetchWeeklyAnime() {
        // Logique pour récupérer les animes pour la semaine
        // En fonction des dates de sortie
    }
}
