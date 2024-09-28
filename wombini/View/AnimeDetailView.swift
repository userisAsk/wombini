import SwiftUI
import Foundation

struct AnimeDetailView: View {
    var anime: AnimeModel // The anime model

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Anime poster and title overlay
                    ZStack(alignment: .bottomLeading) {
                        // Display the anime poster
                        if let url = anime.coverImage.large, let imageUrl = URL(string: url) {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .padding(10)
                                    .frame(width: UIScreen.main.bounds.width, height: 200)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                            }
                        }

                        // Add a semi-transparent overlay for the title
                        VStack(alignment: .leading) {
                            Text(anime.title.romaji)
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                                .padding(.leading, 10)
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
              
                    }
                    .frame(height: 300)
                    .shadow(color: Color.black.opacity(0.6), radius: 20, x: 0, y: 10) // Apply drop shadow at the bottom

                    // Anime description
                    if let description = anime.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        Text("Pas de description disponible.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.top) // Add top padding
            }
            .background(Color.customBackgroundColor.edgesIgnoringSafeArea(.all)) // Apply custom background
            .navigationBarTitleDisplayMode(.inline) // Keep navigation title inline
        }
    }
}
