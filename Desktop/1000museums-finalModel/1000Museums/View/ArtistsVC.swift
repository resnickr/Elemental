//ArtistsViewController.swift

import UIKit

class ArtistsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // stored properties
    var artistsDisplayed: [Artist] = []
    var artistDict = [String:[Artist]]()
    var artistSectionTitles = [String]()
    
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var theSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            TheModel.sharedInstance.artistArr  = TheModel.sharedInstance.getArtists()
            self.artistsDisplayed = TheModel.sharedInstance.artistArr
            self.artistDictSetup()
            self.theTableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            artistsDisplayed = TheModel.sharedInstance.artistArr;
            self.artistDictSetup()
            theTableView.reloadData()
            return
        }
        artistsDisplayed = TheModel.sharedInstance.artistArr.filter ({ artist -> Bool in
            guard let text = searchBar.text else { return false}
            return artist.name!.localizedCaseInsensitiveContains(text)
        })
        self.artistDictSetup()
        self.theTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let artistKey = artistSectionTitles[section]
        if let artistValues = artistDict[artistKey] {
            return artistValues.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artistKey = artistSectionTitles[indexPath.section]
        if let artistValues = artistDict[artistKey] {
            TheModel.sharedInstance.artistToDisplay = artistValues[indexPath.item]
            performSegue(withIdentifier: "fromArtistToWork", sender: nil)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "locationCell", for: indexPath) as! LocationCell
        let artistKey = artistSectionTitles[indexPath.section]
        if let artistValues = artistDict[artistKey] {
            cell.name.text = artistValues[indexPath.item].name
            cell.numWorks.text = String(format: "Works: %d", artistValues[indexPath.item].workCount)
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return artistSectionTitles.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return artistSectionTitles
    }
    
    func artistDictSetup() {
        self.artistDict.removeAll()
        self.artistSectionTitles = []
        for artist in artistsDisplayed {
            let artistKey = String(artist.name!.prefix(1))
            if var artistValues = artistDict[artistKey] {
                artistValues.append(artist)
                artistDict[artistKey] = artistValues
            } else {
                artistDict[artistKey] = [artist]
            }
        }
        artistSectionTitles = [String](artistDict.keys)
        artistSectionTitles = artistSectionTitles.sorted(by: <)
    }

}

