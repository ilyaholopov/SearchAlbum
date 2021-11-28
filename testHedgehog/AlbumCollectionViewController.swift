//
//  AlbumCollectionViewController.swift
//  testHedgehog
//
//  Created by Илья Холопов on 02.11.2021.
//

import UIKit


private let itemsPerRow: CGFloat = 2
private let sectionInsets = UIEdgeInsets(
  top: 20.0,
  left: 20.0,
  bottom: 20.0,
  right: 20.0)
private var urlImage: String = ""
private var resultsAlbums = [results]()

class AlbumCollectionViewController: UICollectionViewController {
    
    private var dataProvider = DataProvider()
    private var timer: Timer?
    private var resultsAlbums = [results]()
    private var urlComponents = URLComponents()
    
    private var networkDataFetcher = NetworkDataFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        collectionView.reloadData()
    }
    
    private func setupURLComponents(searchText: String){
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/search"
        urlComponents.queryItems = [
           URLQueryItem(name: "term", value: searchText),
           URLQueryItem(name: "entity", value: "album")
        ]
    }
    
    private func setupSearchBar(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsAlbums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumCollectionViewCell
        var textURL = resultsAlbums[indexPath.item].artworkUrl100!
        textURL = textURL.replacingOccurrences(of: "100x100", with: "150x150")
        let url = URL(string: textURL)!
        dataProvider.downloadImage(url: url) { image in
            cell.imageView.image = image
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondViewController = storyboard.instantiateViewController(identifier: "SecondVC") as? SecondVC else { return }
        secondViewController.idAlbum = resultsAlbums[indexPath.item].collectionId!
        show(secondViewController, sender: nil)
    }
    

}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlbumCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UISearchBarDelegate

extension AlbumCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            self.setupURLComponents(searchText: searchText)
            self.networkDataFetcher.fetchAlbums(urlComponents: self.urlComponents) { [weak self] (answer) in
                self?.resultsAlbums = answer!.results
                self?.collectionView.reloadData()
                self?.resultsAlbums = self?.resultsAlbums.sorted(by: { (item1, item2) -> Bool in
                    let item1Name = item1.collectionName ?? ""
                    let item2Name = item2.collectionName ?? ""
                    return (item1Name.localizedCaseInsensitiveCompare(item2Name) == .orderedAscending)
                }) ?? []
            }
            
        })
    }

}
