//
//  MusicCell.swift
//  Music App
//
//  Created by Дархан Есенкул on 28.03.2023.
//

import UIKit

class MusicCell: UITableViewCell {

    var musicImageView = UIImageView()
    var musicTitleLabel = UILabel()
    var musicArtistLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(musicImageView)
        addSubview(musicTitleLabel)
        addSubview(musicArtistLabel)
        configureImageView()
        configureTitleLabel()
        configureArtistLabel()
        setImageConstraints()
        setTitleLabelConstraints()
        setArtistLabelConstraints()
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  
    
    func set(music: MusicResponseModel){
        musicTitleLabel.text = music.trackName
        musicArtistLabel.text = music.artistName
        guard let url = URL(string: music.artworkUrl100) else{return}
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if error == nil{
                if let imageData = data{
                    DispatchQueue.main.async {
                        self.musicImageView.image = UIImage(data: imageData)
                    }
                }
            }
            else{
                print("Error: \(error!.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func configureImageView(){
        musicImageView.layer.cornerRadius = 10
        musicImageView.clipsToBounds = true
    }
    
    func configureTitleLabel(){
        musicTitleLabel.numberOfLines = 0
        musicTitleLabel.adjustsFontSizeToFitWidth = true
        musicTitleLabel.font = UIFont(name: "Futura", size: 20)
    }
    func configureArtistLabel(){
        musicArtistLabel.numberOfLines = 0
        musicArtistLabel.adjustsFontSizeToFitWidth = true
        musicArtistLabel.textColor = UIColor.gray
        
    }

    func setImageConstraints(){
        musicImageView.translatesAutoresizingMaskIntoConstraints = false
        musicImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        musicImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        musicImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        musicImageView.widthAnchor.constraint(equalTo: musicImageView.heightAnchor, multiplier: 1/1).isActive = true
    }
    
    func setTitleLabelConstraints(){
        musicTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        musicTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        musicTitleLabel.leadingAnchor.constraint(equalTo: musicImageView.trailingAnchor, constant: 20).isActive = true
        musicTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        musicTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    func setArtistLabelConstraints(){
        musicArtistLabel.translatesAutoresizingMaskIntoConstraints = false
        musicArtistLabel.topAnchor.constraint(equalTo: musicTitleLabel.topAnchor, constant: 40).isActive = true
        musicArtistLabel.leadingAnchor.constraint(equalTo: musicImageView.trailingAnchor, constant: 20).isActive = true
        musicArtistLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        musicArtistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
}
