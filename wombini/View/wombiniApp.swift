import SwiftUI
import Combine

struct Anime: Codable, Identifiable {
    let id: Int
    let title: String
    let images: AnimeImages

    struct AnimeImages: Codable {
        let jpg: ImageURL
    }

    struct ImageURL: Codable {
        let image_url: String
    }
}

class AnimeViewModel: ObservableObject {
    @Published var animes: [Anime] = []
    private var cancellables = Set<AnyCancellable>()

    func fetchAnimes() {
        guard let url = URL(string: "https://api.jikan.moe/v4/top/anime?limit=11") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: AnimeListResponse.self, decoder: JSONDecoder())
            .map { $0.animes } // Utilisez la propriété `animes` de `AnimeListResponse`
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$animes)
    }

}

struct AnimeListResponse: Codable {
    struct AnimeData: Codable {
        let mal_id: Int
        let title: String
        let images: Anime.AnimeImages

        var id: Int {
            mal_id
        }
    }

    let data: [AnimeData]

    var animes: [Anime] {
        data.map { Anime(id: $0.mal_id, title: $0.title, images: $0.images) }
    }
}

struct ContentView: View {
    @StateObject var viewModel = AnimeViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.animes) { anime in
                HStack {
                    AsyncImage(url: URL(string: anime.images.jpg.image_url)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                    
                    Text(anime.title)
                        .font(.headline)
                }
            }
            .navigationTitle("Top 10 Anime")
            .onAppear {
                viewModel.fetchAnimes()
            }
        }
    }
}

@main
struct AnimeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
