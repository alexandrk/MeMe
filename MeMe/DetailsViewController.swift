//
//  DetailsViewController.swift
//  MeMe
//
//  Created by Alexander on 11/3/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var meme: Meme?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let meme = self.meme {
            self.imageView.image = meme.imageMemed
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
