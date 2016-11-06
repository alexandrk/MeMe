//
//  TableViewController.swift
//  MeMe
//
//  Created by Alexander on 10/31/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: CONTROLLER LIFECYCLE
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: DELEGATES

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableCell", for: indexPath) as! MyTableViewCell
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        cell.cellImage.image = appDelegate.memes[indexPath.row].imageOriginal
        cell.topTextLabel.text = appDelegate.memes[indexPath.row].textTop
        cell.bottomTextLabel.text = appDelegate.memes[indexPath.row].textBottom
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController")
            as! DetailsViewController

        vc.meme = appDelegate.memes[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
