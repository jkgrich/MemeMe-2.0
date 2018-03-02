//
//  TableViewController.swift
//  MemeMe
//
//  Created by Justin Richardson on 2018-02-26.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: Properties
    
    let cellReuseIdentifier = "TableViewCell"
    let plusButton = UIBarButtonSystemItem.add
    
    // MARK: Model

    var storedMemesArray: [Meme]!
    
    let memeTitle: [String] = [
        "Description",
        "Description",
        "Description",
        "Description"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        storedMemesArray = appDelegate.memes
        
        self.tableView.reloadData()
    }
    
    @objc func editScreen() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "EditScreenViewController")as! EditScreenViewController
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns the correct number of rows
        return self.storedMemesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Method to return cell with the correct reuseidentifier and populated with the correct data.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        let meme = self.storedMemesArray[(indexPath as NSIndexPath).row]
        
        // Configure the cell...
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = self.memeTitle[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.storedMemesArray[indexPath.row]

        self.navigationController!.pushViewController(detailController, animated: true)
    }

}
