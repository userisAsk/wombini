import SwiftUI
import Combine // Importer Combine pour le Timer

extension Color {
    static let customBackgroundColor = Color(red: 20 / 255, green: 20 / 255, blue: 20 / 255)
}

struct Genre: Identifiable {
    let id = UUID()
    let name: String
}

struct HomeView: View {
    @StateObject private var controller = AnimeListViewController() // État de l'objet pour le contrôleur
    @State private var currentIndex: Int // Index pour le slider
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> // Déclaration du timer

    let genres: [Genre] = [
        Genre(name: "Action"),
        Genre(name: "Adventure"),
        Genre(name: "Comedy"),
        Genre(name: "Drama"),
        Genre(name: "Fantasy"),
        Genre(name: "Horror"),
        Genre(name: "Mystery"),
        Genre(name: "Romance"),
        Genre(name: "Sci-Fi"),
        Genre(name: "Thriller")
    ]

    init() {
        // Initialiser le timer avec une publication automatique
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
        _currentIndex = State(initialValue: 0) // Initialisation temporaire pour compiler
    }

    var body: some View {
        ZStack {
            // Couleur de fond
            Color.customBackgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Logo
                HStack {
                    Image("wblogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200) // Ajustez la taille selon vos besoins
                        .padding(.leading, 20)
                        .offset(x: -55, y:-10)
                    Spacer()
                }

                // Slider d'animes
                TabView(selection: $currentIndex) {
                    // Vérifier que animeList contient des éléments
                    if !controller.animeList.isEmpty {
                        ForEach(controller.animeList.indices, id: \.self) { index in
                            // Créer une vue pour chaque anime
                            AnimeView(anime: controller.animeList[index])
                                .tag(index) // Taguer chaque vue avec son index
                        }
                    } else {
                        // Afficher un message si aucune donnée n'est disponible
                        Text("Aucun anime disponible.")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Style de page pour le TabView
                .frame(height: 300) // Set a fixed height for the TabView
                .onReceive(timer) { _ in // Utilisation correcte du timer
                    if !controller.animeList.isEmpty {
                        withAnimation(.easeInOut(duration: 0.5)) { // Ajout d'une animation
                            currentIndex = (currentIndex + 1) % controller.animeList.count // Changer l'index automatiquement
                        }
                    }
                }

                // Dots du TabView positionnés sur l'image
                HStack {
                    Spacer()
                    PageControl(numberOfPages: controller.animeList.count, currentPage: $currentIndex)
                        .frame(width: UIScreen.main.bounds.width * 0.95)
                    Spacer()
                }

                // Horizontal Genre List
                GenreScrollView(genres: genres) // Add the genre scroll view
                FilterButtonsView()

                Spacer()
            }
        }
        .onAppear {
            controller.fetchAnimeData() // Récupérer les données des animes lors de l'apparition de la vue
            if !controller.animeList.isEmpty {
                currentIndex = controller.animeList.count / 2 // Commence au milieu de la liste
            }
        }
    }
}

struct GenreScrollView: View {
    let genres: [Genre]
    
    var body: some View {
        VStack {
            Text("Genres")
                .font(.title2)
                .foregroundColor(.white)
                .padding()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(genres) { genre in
                        Button(action: {
                            print("Selected genre: \(genre.name)") // Handle genre selection
                        }) {
                            Text(genre.name)
                                .foregroundColor(.white)
                                .padding(.horizontal, 15) // Adjust horizontal padding for width
                                .padding(.vertical, 8) // Adjust vertical padding for height
                                .background(Color(red: 31/255, green: 30/255, blue: 30/255))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal) // Padding around the entire horizontal ScrollView
            }
        }
        .background(Color.customBackgroundColor.opacity(1)) // Background for the genre section

        .padding()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Structure personnalisée pour arrondir les coins spécifiques
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct FilterButtonsView: View {
    var body: some View {
        HStack(spacing: 0) { // Spacing à 0 pour coller les boutons
            Button(action: {
                print("Newest tapped")
            }) {
                Text("Newest")
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color(red: 31 / 255, green: 30 / 255, blue: 30 / 255)) // Couleur du bouton
                    .overlay( // Ajout d'un contour blanc
                        RoundedRectangle(cornerRadius: 0) // Pas d'arrondi
                            .stroke(Color.gray, lineWidth: 1) // Couleur et épaisseur du contour
                    )
            }

            Button(action: {
                print("Popular tapped")
            }) {
                Text("Popular")
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color(red: 31 / 255, green: 30 / 255, blue: 30 / 255))
                    .overlay( // Ajout d'un contour blanc
                        RoundedRectangle(cornerRadius: 0) // Pas d'arrondi
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
            }

            Button(action: {
                print("Top Rated tapped")
            }) {
                Text("Top Rated")
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color(red: 31 / 255, green: 30 / 255, blue: 30 / 255))
                    .overlay( // Ajout d'un contour blanc
                        RoundedRectangle(cornerRadius: 0) // Pas d'arrondi
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
            }
        }
        .padding(.top, 20) // Espace au-dessus des boutons
    }
}




struct AnimeView: View {
    var anime: AnimeModel? // The anime model
    @State private var showDetails = false // State for showing details
    
    var body: some View {
        VStack {
            if let anime = anime {
                ZStack(alignment: .bottomLeading) {
                    // Display the anime poster
                    if let url = anime.coverImage.large, let imageUrl = URL(string: url) {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: 200)
                                .clipped()
                                .cornerRadius(15)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    // Dark filter over image
                    Rectangle()
                        .foregroundColor(Color.black.opacity(0.5))
                        .cornerRadius(15)
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 200)
                    
                    // Anime title and "Details" button
                    VStack(alignment: .leading) {
                        Text(anime.title.romaji)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(1), radius: 10, x: 10, y: 10)

                        // "Details" button to navigate
                        Button(action: {
                            showDetails = true // Trigger the modal view
                        }) {
                            Label("Détails", systemImage: "info.circle")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 130, height: 40)
                                .background(
                                    Color.gray.opacity(0.5)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.6), radius: 1, x: 0, y: 1)
                                )
                        }
                        .padding(.top, 10)
                        .fullScreenCover(isPresented: $showDetails) {
                            AnimeDetailView(anime: anime) // Full-screen detail view
                        }
                    }
                    .padding()
                }
                .padding()
                .background(Color.clear)
                .cornerRadius(15)
                .padding()
            } else {
                Text("Aucun anime disponible.")
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
        .padding(.top, 0)
    }
}

// Contrôle personnalisé pour les dots
struct PageControl: View {
    var numberOfPages: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack(spacing: 8) { // Espacement entre les dots
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.blue : Color.white.opacity(0.5)) // Couleur selon l'état
                    .frame(width: index == currentPage ? 12 : 8, height: index == currentPage ? 12 : 8) // Taille des dots
            }
        }
    }
}

// Prévisualisation
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
            .previewLayout(.sizeThatFits)
    }
}
