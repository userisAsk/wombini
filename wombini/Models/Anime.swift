//
//  Anime.swift
//  wombini
//
//  Created by Jeremie Gavin on 9/27/24.
//

import Foundation

struct Anime: Identifiable, Codable {
    let id: Int
    let title: String
    let mainPicture: MainPicture
    
    struct MainPicture: Codable {
        let medium: String
        let large: String
    }
}

struct AnimeResponse: Codable {
    let data: [AnimeNode]
}

struct AnimeNode: Codable {
    let node: Anime
}
