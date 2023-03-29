//
//  MusicModel.swift
//  Music App
//
//  Created by Дархан Есенкул on 28.03.2023.
//

import Foundation

struct MusicModel: Decodable{
    let results: [MusicResponseModel]
}

struct MusicResponseModel: Decodable{
    let artistName: String
    let trackName: String
    let previewUrl: String
    let artworkUrl30: String
    let artworkUrl60: String
    let artworkUrl100: String
}
