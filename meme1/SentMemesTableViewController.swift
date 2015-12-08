//
//  SentMemesTableViewController.swift
//  meme1
//
//  Created by Evan Scharfer on 12/4/15.
//  Copyright © 2015 Evan Scharfer. All rights reserved.
//


import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var memeTable: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memeTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        let memes = appDelegate.memes
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        let meme : Meme = appDelegate.memes[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")! as UITableViewCell
        
        if let image = cell.imageView {
            image.image = meme.memedImage
        }
        
        cell.textLabel!.text = "\(meme.topText) ... \(meme.bottomText)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        
        var memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        let meme : Meme = memes[indexPath.row]
        
        detailController.meme = meme
        
        //detailController.originalImage
        navigationController!.pushViewController(detailController, animated: true)
        
    }
}