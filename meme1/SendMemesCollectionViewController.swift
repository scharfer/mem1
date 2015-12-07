//
//  SendMemesCollectionViewController.swift
//  meme1
//
//  Created by Evan Scharfer on 12/7/15.
//  Copyright © 2015 Evan Scharfer. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
   
    @IBOutlet weak var viewFlow: UICollectionViewFlowLayout!
    
        
    override func viewDidLoad() {
        let space : CGFloat = 3
        let diminision = (view.frame.size.width - (2 * space)) / 3.0
        
        // set the spacing
        viewFlow.minimumInteritemSpacing = space
        viewFlow.minimumLineSpacing = space
        viewFlow.itemSize = CGSizeMake(diminision,diminision)
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // make sure its already the freshest data
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        // get the meme
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.item]
        cell.setText(meme.topText, bottomString: meme.bottomText)
        // set the view
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        
        return cell

    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        
        var memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        let meme : Meme = memes[indexPath.row]
        
        detailController.meme = meme
        detailController.memeLocation = indexPath.row
        
        //detailController.originalImage
        navigationController!.pushViewController(detailController, animated: true)
    
    }

}