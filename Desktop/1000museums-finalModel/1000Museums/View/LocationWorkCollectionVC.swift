//
//  WorkVC.swift
//  1000Museums
//
//  Created by Brian Terry on 2/18/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class LocationWorkCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var theCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        let myGroup = DispatchGroup()
        TheModel.sharedInstance.museumWorkArr = []
        if let theMuseum = TheModel.sharedInstance.museumToDisplay {
            myGroup.enter()
            let works = TheModel.sharedInstance.getWorksForLocation(id: theMuseum.id)
            if (works.count > 0) {
                TheModel.sharedInstance.museumWorkArr = works
                myGroup.leave()
            }else {
                TheModel.sharedInstance.downloadWorksForLocation(id: theMuseum.id) {
                    TheModel.sharedInstance.museumWorkArr = TheModel.sharedInstance.getWorksForLocation(id: theMuseum.id)
                    myGroup.leave()
                }
            }
        }
        myGroup.notify(queue: .main) {
            self.theCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TheModel.sharedInstance.museumWorkArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "Cell", for: indexPath) as! WorkCell
        cell.workNameLabel.text = TheModel.sharedInstance.museumWorkArr[indexPath.item].name ?? ""
        cell.workArtistLabel.text = TheModel.sharedInstance.museumWorkArr[indexPath.item].artist ?? ""
        if let theImage = TheModel.sharedInstance.museumWorkArr[indexPath.item].thumbnailFile {
            let aImage = UIImage(data: theImage as Data)
            cell.workThumbnail.image = aImage
        } else {
            TheModel.sharedInstance.downloadWorkThumbnail(work: TheModel.sharedInstance.museumWorkArr[indexPath.item]) { (data) in
                if let data = data {
                    DispatchQueue.main.async {
                        
                        cell.workThumbnail.image = UIImage(data: data as Data)
                    }
                } else {
                    print(String(format:"error in collectionview museum locationID: %d", TheModel.sharedInstance.museumWorkArr[indexPath.item].locationID))
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TheModel.sharedInstance.locationWork = TheModel.sharedInstance.museumWorkArr[indexPath.item]
        performSegue(withIdentifier: "workSegue1", sender: self)
        
    }
    
}

