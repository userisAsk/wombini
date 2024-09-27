//
//  AnimeListViewController.swift
//  wombini
//
//  Created by Jeremie Gavin on 9/27/24.
//

import Foundation
import UIKit

class AnimeListViewController: UIViewController {
    private let animeService = AnimeAPIService()
    private var animes: [Anime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAnimes()
    }
    
    private func fetchAnimes() {
        animeService.fetchAnimeList { [weak self] result in
            switch result {
            case .success(let animes):
                self?.animes = animes
                DispatchQueue.main.async {
                    // Ici, nous mettrons à jour l'UI une fois que nous aurons une vue
                    print("Animes récupérés avec succès : \(animes.count)")
                }
            case .failure(let error):
                print("Erreur lors de la récupération des animes : \(error.localizedDescription)")
            }
        }
    }
}
