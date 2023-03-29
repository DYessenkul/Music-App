//
//  NetworkManager.swift
//  Music App
//
//  Created by Дархан Есенкул on 28.03.2023.
//

import Foundation

protocol NetworkManagerDelegate{
    func didUpdateMusics(with musics: [MusicResponseModel])
}

struct NetworkManager{
    var delegate: NetworkManagerDelegate?
    
    func getMusic(){
        let urlString = "https://itunes.apple.com/search?term=dua+lipa&limit=10"
        guard let url = URL(string: urlString) else{return}
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error{
                print("Server Eror \(error.localizedDescription)")
            }else{
                guard let safeData = data else{return}
                do{
                    let musics = try JSONDecoder().decode(MusicModel.self, from: safeData)
                    DispatchQueue.main.async {
                        delegate?.didUpdateMusics(with: musics.results)
                    }
                }
                catch{
                    print("Parsing Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func search(with query: String){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{return}
        let urlString = "https://itunes.apple.com/search?term=\(query)&limit=15"
        guard let url = URL(string: urlString) else{return}
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error{
                print("Server Eror \(error.localizedDescription)")
            }else{
                guard let safeData = data else{return}
                do{
                    let musics = try JSONDecoder().decode(MusicModel.self, from: safeData)
                    DispatchQueue.main.async {
                        delegate?.didUpdateMusics(with: musics.results)
                    }
                }
                catch{
                    print("Parsing Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
