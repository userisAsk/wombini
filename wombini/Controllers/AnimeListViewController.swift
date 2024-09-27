import Foundation
import SwiftUI

class AnimeListViewController: ObservableObject {
    @Published var anime: AnimeModel?

    func fetchAnimeData() {
        AnimeAPIService.shared.fetchAnimeData { [weak self] anime in
            self?.anime = anime
        }
    }
}
