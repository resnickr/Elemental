//
//  WorkVC.swift
//  1000Museums
//
//  Created by Brian Terry on 2/18/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ArtistWorkCollectionVC: UICollectionViewController {
    
    @IBOutlet var theCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        let myGroup = DispatchGroup()
        TheModel.sharedInstance.artistWorkArr = []
        if let theArtist = TheModel.sharedInstance.artistToDisplay {
            myGroup.enter()
            let works = TheModel.sharedInstance.getWorksForArtist(id: theArtist.id)
            if (works.count > 0) {
                TheModel.sharedInstance.artistWorkArr = works
                myGroup.leave()
            }else {
                TheModel.sharedInstance.downloadWorksForArtist(id: theArtist.id) {
                    TheModel.sharedInstance.artistWorkArr = TheModel.sharedInstance.getWorksForArtist(id: theArtist.id)
                    myGroup.leave()
                }
            }
        }
        myGroup.notify(queue: .main) {
            self.theCollectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TheModel.sharedInstance.artistWorkArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "Cell", for: indexPath) as! WorkCell
        cell.workNameLabel.text = TheModel.sharedInstance.artistWorkArr[indexPath.item].name  ?? ""
        cell.workArtistLabel.text = TheModel.sharedInstance.artistWorkArr[indexPath.item].artist ?? ""
        if let theImage = TheModel.sharedInstance.artistWorkArr[indexPath.item].thumbnailFile {
            let aImage = UIImage(data: theImage as Data)
            cell.workThumbnail.image = aImage
        } else {
            TheModel.sharedInstance.downloadWorkThumbnail(work: TheModel.sharedInstance.artistWorkArr[indexPath.item]) { (data) in
                if let data = data {
                    DispatchQueue.main.async {
                        
                        cell.workThumbnail.image = UIImage(data: data as Data)
                    }
                } else {
                    print(String(format:"error in collectionview artist locationID: %d", TheModel.sharedInstance.artistWorkArr[indexPath.item].locationID))
                }
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TheModel.sharedInstance.artistWork = TheModel.sharedInstance.artistWorkArr[indexPath.item]
        performSegue(withIdentifier: "workSegue2", sender: nil)
    }
    
}


