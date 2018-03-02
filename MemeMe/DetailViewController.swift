//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Justin Richardson on 2018-02-28.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: Properties
    var meme: Meme!
    
    // MARK: OUTLETS
    @IBOutlet weak var memeImageView: UIImageView!
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // pass meme data from table/collection View Controller
        self.memeImageView.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
