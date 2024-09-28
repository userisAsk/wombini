import Foundation

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
