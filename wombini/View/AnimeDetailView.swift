import SwiftUI
import Foundation

struct AnimeDetailView: View {
    var anime: Anime

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Anime poster and title overlay
                    ZStack(alignment: .bottomLeading) {
                        if let imageUrl = URL(string: anime.images.jpg.image_url) {
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

                        VStack(alignment: .leading) {
                            Text(anime.title)
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                                .padding(.leading, 10)
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    }
                    .frame(height: 300)
                    .shadow(color: Color.black.opacity(0.6), radius: 20, x: 0, y: 10)

                    Text("No description available.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    Spacer()
                }
                .padding(.top)
            }
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
