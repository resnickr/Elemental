//MuseumsViewController.swift

import UIKit

class LocationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
  
    // stored properties

    var museumsDisplayed: [Location] = []
    var museumDict = [String:[Location]]()
    var museumSectionTitles = [String]()

    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var theSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TheModel.sharedInstance.museumArr = TheModel.sharedInstance.getMuseums()
        self.museumsDisplayed = TheModel.sharedInstance.museumArr
        self.museumDictSetup()
        self.theTableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            museumsDisplayed = TheModel.sharedInstance.museumArr;
            self.museumDictSetup()
            theTableView.reloadData()
            return
        }
        museumsDisplayed = TheModel.sharedInstance.museumArr.filter ({ location -> Bool in
            guard let text = searchBar.text else { return false}
            return location.name!.localizedCaseInsensitiveContains(text)
        })
        self.museumDictSetup()
        self.theTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let museumKey = museumSectionTitles[section]
        if let museumValues = museumDict[museumKey] {
            return museumValues.count
        }
        return 0
    }
    // selection made in table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let museumKey = museumSectionTitles[indexPath.section]
        if let museumValues = museumDict[museumKey] {
            TheModel.sharedInstance.museumToDisplay = museumValues[indexPath.item]
            performSegue(withIdentifier: "fromMuseumToWork", sender: nil)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "locationCell", for: indexPath) as! LocationCell
        let museumKey = museumSectionTitles[indexPath.section]
        if let museumValues = museumDict[museumKey] {
            cell.name.text = museumValues[indexPath.item].name!
            cell.country.text = museumValues[indexPath.item].country!
            cell.numWorks.text = String(format: "Works: %d", museumValues[indexPath.item].workCount)
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return museumSectionTitles.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return museumSectionTitles
    }
    
    func museumDictSetup() {
        self.museumDict.removeAll()
        self.museumSectionTitles = []
        for museum in museumsDisplayed {
            let museumKey = String(museum.name!.prefix(1))
            if var museumValues = museumDict[museumKey] {
                museumValues.append(museum)
                museumDict[museumKey] = museumValues
            } else {
                museumDict[museumKey] = [museum]
            }
        }
        museumSectionTitles = [String](museumDict.keys)
        museumSectionTitles = museumSectionTitles.sorted(by: <)
    }
    
}
