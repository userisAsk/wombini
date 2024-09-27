import Foundation

struct AnimeResponse: Codable {
    let data: AnimeData?
}

struct AnimeData: Codable {
    let Media: AnimeModel
}

struct AnimeModel: Codable {
    let title: AnimeTitle
    let description: String
    let coverImage: AnimeCoverImage

    struct AnimeTitle: Codable {
        let romaji: String
    }

    struct AnimeCoverImage: Codable {
        let large: String
    }
}
