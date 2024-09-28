import Foundation
import SwiftUI

struct AnimeGridView: View {
    var animeList: [Anime]
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 150)) // Nombre d'éléments par ligne, adaptatif
        ]
        
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(animeList) { anime in
                VStack {
                    AsyncImage(url: URL(string: anime.images.jpg.image_url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Text(anime.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // Affichez l'année de sortie
                    Text(anime.releaseDate) // Utiliser directement la propriété releaseDate
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
    }
}
