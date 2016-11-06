//
//  CollectionViewController.swift
//  MeMe
//
//  Created by Alexander on 10/31/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import UIKit

private let reuseIdentifier = "sentMemeCollectionCell"

class CollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func calculateCellSizeAndUpdateFlowLayout(_ screenWidth: CGFloat){
        
        if flowLayout != nil {
            let margin: CGFloat = 10.0
            let cellsPerRow: CGFloat = 3.0
            let size = (screenWidth - margin * (cellsPerRow + 2)) / cellsPerRow
            
            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.itemSize = CGSize(width: size, height: size)
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        // Checking if the viewController is loaded and attached to the window (is displayed)
        // Prevents the code to be executed on screen rotation, if this viewControler is not on screen
        if (self.isViewLoaded && self.view.window != nil){
            print("in CollectionViewController's viewWillTransition")
            super.viewWillTransition(to: size, with: coordinator)
            
            calculateCellSizeAndUpdateFlowLayout(size.width)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
        calculateCellSizeAndUpdateFlowLayout(self.view.bounds.width)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        cell.image.image = appDelegate.memes[indexPath.row].imageOriginal
        cell.topText.text = appDelegate.memes[indexPath.row].textTop
        cell.bottomText.text = appDelegate.memes[indexPath.row].textBottom
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController")
            as! DetailsViewController
        
        vc.meme = appDelegate.memes[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
