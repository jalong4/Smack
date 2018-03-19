//
//  AvatarPickerVC.swift
//  Smack
//
//  Created by Jim Long on 3/18/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    // Outlets
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // Variables:
    
    var avatarType = AvatarType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
        

    }

    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        avatarType = AvatarType(rawValue: Int(segmentControl.selectedSegmentIndex)) ?? .dark
        collectionview.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionview.dequeueReusableCell(withReuseIdentifier: AVATAR_CELL, for: indexPath) as? AvatarCell
        else {
            return AvatarCell()
        }
        
        cell.configureCell(index: indexPath.item, type: avatarType)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns: CGFloat = 3
        
        if UIScreen.main.bounds.width > 320 {   // width of iphone SE
            numberOfColumns = 4
        }
        
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDimension = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        return CGSize(width: cellDimension, height: cellDimension)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDataService.instance.setAvataraName(avatarName: "\(avatarType)\(indexPath.item)")
        dismiss(animated: true, completion: nil)
    }
}
