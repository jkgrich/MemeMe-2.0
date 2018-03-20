//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Justin Richardson on 2018-02-28.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    
    //MARK: Properties
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.contentMode = .scaleAspectFit
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionView", for: indexPath) as! CollectionViewCell
        let memeToShow = self.memes[indexPath.row]
        // Configure the cell
        cell.memeImageView.image = memeToShow.memedImage
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.memes[indexPath.row]
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }

}
