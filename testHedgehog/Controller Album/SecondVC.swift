//
//  SecondVC.swift
//  testHedgehog
//
//  Created by Илья Холопов on 03.11.2021.
//

import UIKit

private var resultsSongs = [results]()

class SecondVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageAlbum: UIImageView!
    @IBOutlet weak var nameAlbumLabel: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var tableViewSongs: UITableView!
    
    var idAlbum: Int = 0
    private var urlComponents = URLComponents()
    private var networkDataFetcher = NetworkDataFetcher()
    private var dataProvider = DataProvider()
    private let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allHidden(value: true)
        setupActivityIndicator()
        
        tableViewSongs.dataSource = self
        tableViewSongs.delegate = self
        tableViewSongs.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myActivityIndicator.startAnimating()
        setupURLComponents(searchID: String(idAlbum))
        networkDataFetcher.fetchAlbums(urlComponents: self.urlComponents) { (answer) in
            resultsSongs = answer!.results
            self.settingValues()
        }
    }
    
    private func settingValues() {
        nameAlbumLabel.text = "Название альбома: \(resultsSongs[0].collectionName!)"
        label2.text = "Автор: \(resultsSongs[0].artistName!)"
        genreLabel.text = "Жанр: \(resultsSongs[0].primaryGenreName!)"
        getImageOnUrl()
        tableViewSongs.reloadData()
        myActivityIndicator.stopAnimating()
        allHidden(value: false)
    }
    
    private func setupActivityIndicator() {
        myActivityIndicator.center = view.center
        myActivityIndicator.color = .black
        view.addSubview(myActivityIndicator)
    }
    
    private func setupURLComponents(searchID: String){
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/lookup"
        urlComponents.queryItems = [
           URLQueryItem(name: "id", value: searchID),
           URLQueryItem(name: "entity", value: "song")
        ]
    }
    
    private func allHidden(value: Bool){
        imageAlbum.isHidden = value
        nameAlbumLabel.isHidden = value
        label2.isHidden = value
        genreLabel.isHidden = value
        tableViewSongs.isHidden = value
    }
    
    func getImageOnUrl(){
        var textURL = resultsSongs[0].artworkUrl100!
        textURL = textURL.replacingOccurrences(of: "100x100", with: "150x150")
        let url = URL(string: textURL)!
        dataProvider.downloadImage(url: url) { image in
            self.imageAlbum.image = image
        }
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsSongs.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSong", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "\(indexPath.row + 1). \(resultsSongs[indexPath.row + 1].trackName!)"
        cell.contentConfiguration = content
        return cell
    }
}

