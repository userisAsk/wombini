import SwiftUI
import Combine

extension Color {
    static let customBackgroundColor = Color(red: 20 / 255, green: 20 / 255, blue: 20 / 255)
}

struct Genre: Identifiable {
    let id = UUID()
    let name: String
}

struct HomeView: View {
    @StateObject private var controller = AnimeController()
    @State private var currentIndex: Int = 0
    private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

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

    var body: some View {
        NavigationView { // Ajoutez NavigationView ici
            ZStack {
                Color.customBackgroundColor
                    .edgesIgnoringSafeArea(.all)

                ScrollView { // Wrap the VStack in a ScrollView
                    VStack {
                        // Logo
                        HStack {
                            Image("wblogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .padding(.leading, 20)
                                .offset(x: -55, y: -10)
                            Spacer()
                        }

                        // Slider for anime
                        TabView(selection: $currentIndex) {
                            if !controller.animeList.isEmpty {
                                ForEach(controller.animeList.indices, id: \.self) { index in
                                    AnimeView(anime: controller.animeList[index])
                                        .tag(index)
                                }
                            } else {
                                Text("Aucun anime disponible.")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 300)
                        .onReceive(timer) { _ in
                            if !controller.animeList.isEmpty {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentIndex = (currentIndex + 1) % controller.animeList.count
                                }
                            }
                        }

                        // Page Control
                        HStack {
                            Spacer()
                            PageControl(numberOfPages: controller.animeList.count, currentPage: $currentIndex)
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                            Spacer()
                        }

                        // Genre List
                        GenreScrollView(genres: genres)
                        
                        // Filter Buttons
                        FilterButtonsView()
                        
                        if !controller.animeList.isEmpty {
                            AnimeGridView(animeList: controller.animeList)
                        } else {
                            Text("Aucun anime disponible.")
                                .foregroundColor(.white)
                                .font(.title)
                        }

                        Spacer()
                    }
                    .padding(.bottom) // Add padding to avoid content being cut off
                }
            }
            .onAppear {
                controller.fetchAnimeData()
                controller.fetchAllAnimeData()
                if !controller.animeList.isEmpty {
                    currentIndex = controller.animeList.count / 2
                }
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
                            print("Selected genre: \(genre.name)")
                        }) {
                            Text(genre.name)
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(Color(red: 31/255, green: 30/255, blue: 30/255))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.customBackgroundColor.opacity(1))
        .padding()
    }
}

struct FilterButtonsView: View {
    var body: some View {
        HStack(spacing: 0) {
            ForEach(["Newest", "Popular", "Top Rated"], id: \.self) { filter in
                Button(action: {
                    print("\(filter) tapped")
                }) {
                    Text(filter)
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color(red: 31 / 255, green: 30 / 255, blue: 30 / 255))
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                }
            }
        }
        .padding(.top, 20)
    }
}

struct PageControl: View {
    var numberOfPages: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.blue : Color.white.opacity(0.5))
                    .frame(width: index == currentPage ? 12 : 8, height: index == currentPage ? 12 : 8)
            }
        }
    }
}

struct AnimeView: View {
    var anime: Anime

    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                if let imageUrl = URL(string: anime.images.jpg.image_url) {
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

                Rectangle()
                    .foregroundColor(Color.black.opacity(0.5))
                    .cornerRadius(15)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 200)

                VStack(alignment: .leading) {
                    Text(anime.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(1), radius: 10, x: 10, y: 10)
                }
                .padding()
            }
            .padding()
        }
    }
    

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AnimeController())
            .preferredColorScheme(.dark)
    }
}
