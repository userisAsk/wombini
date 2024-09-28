import SwiftUI

struct AnimeDetailView: View {
    var anime: Anime
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: anime.images.jpg.image_url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                
                Text(anime.title)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top)
                
                Text("Release Year: \(anime.releaseDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Ajoutez d'autres détails ici (par exemple, description, genre, etc.)
                
                Spacer()
            }
            .padding()
            .background(Color.customBackgroundColor) // Utilisez votre couleur de fond personnalisée
            .navigationTitle(anime.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
