//
//  TableViewController.swift
//  MeMe
//
//  Created by Alexander on 10/31/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 1",
                          textBottom: "Bottom Text For Image 1",
                          imageOriginal: #imageLiteral(resourceName: "image 1"), imageMemed: #imageLiteral(resourceName: "image 1")))
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 2",
                          textBottom: "Bottom Text For Image 2",
                          imageOriginal: #imageLiteral(resourceName: "image 2"), imageMemed: #imageLiteral(resourceName: "image 2")))
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 3",
                          textBottom: "Bottom Text For Image 3",
                          imageOriginal: #imageLiteral(resourceName: "image 3"), imageMemed: #imageLiteral(resourceName: "image 3")))
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 4",
                          textBottom: "Bottom Text For Image 4",
                          imageOriginal: #imageLiteral(resourceName: "image 4"), imageMemed: #imageLiteral(resourceName: "image 4")))
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 5",
                          textBottom: "Bottom Text For Image 5",
                          imageOriginal: #imageLiteral(resourceName: "image 5"), imageMemed: #imageLiteral(resourceName: "image 5")))
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 6",
                          textBottom: "Bottom Text For Image 6",
                          imageOriginal: #imageLiteral(resourceName: "image 6"), imageMemed: #imageLiteral(resourceName: "image 6")))
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 7",
                          textBottom: "Bottom Text For Image 7",
                          imageOriginal: #imageLiteral(resourceName: "image 7"), imageMemed: #imageLiteral(resourceName: "image 7")))
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 8",
                          textBottom: "Bottom Text For Image 8",
                          imageOriginal: #imageLiteral(resourceName: "image 8"), imageMemed: #imageLiteral(resourceName: "image 8")))
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 9",
                          textBottom: "Bottom Text For Image 9",
                          imageOriginal: #imageLiteral(resourceName: "image 9"), imageMemed: #imageLiteral(resourceName: "image 9")))
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 10",
                          textBottom: "Bottom Text For Image 10",
                          imageOriginal: #imageLiteral(resourceName: "image 10"), imageMemed: #imageLiteral(resourceName: "image 10")))
        appDelegate.memes.append(Meme(textTop: "Top Text For Image 11",
                          textBottom: "Bottom Text For Image 11",
                          imageOriginal: #imageLiteral(resourceName: "image 11"), imageMemed: #imageLiteral(resourceName: "image 11")))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.addNewMeme()
    }

    func addNewMeme() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openNewMemeDialog))
    }
    
    func openNewMemeDialog() {
        let newMemeVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemeView") as! ViewController
        
        present(newMemeVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
