//
//  ViewController.swift
//  Music App
//
//  Created by Дархан Есенкул on 28.03.2023.
//

import UIKit

class ViewController: UIViewController{

    var coordinator: Coordinator?
    var tableView = UITableView()
    let searchController = UISearchController()
    var networkManager = NetworkManager()
    var musics: [MusicResponseModel] = []
    
    struct Cells{
        static let musicCell = "MusicCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Musics"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        networkManager.delegate = self
        configureTableView()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView(){
        view.addSubview(tableView)
        setTableViewDelegate()
        tableView.rowHeight = 100
        tableView.register(MusicCell.self, forCellReuseIdentifier: Cells.musicCell)
        tableView.pin(to: view)
    }
    
    func setTableViewDelegate(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: Coordinating, UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating, NetworkManagerDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        networkManager.search(with: text.trimmingCharacters(in: .whitespaces))
    }
    
    func didUpdateMusics(with musics: [MusicResponseModel]) {
        self.musics = musics
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.musicCell) as! MusicCell
        let music = musics[indexPath.row]
        cell.set(music: music)
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = MusicInfoViewController()
        vc.song = musics[indexPath.row]
//        coordinator?.eventOccured(with: .musicInfoTapped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
}

