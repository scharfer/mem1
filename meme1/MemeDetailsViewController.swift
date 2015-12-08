//
//  MemeDetailsViewController.swift
//  meme1
//
//  Created by Evan Scharfer on 12/8/15.
//  Copyright © 2015 Evan Scharfer. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {

    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    var meme : Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTextAttribute(topText)
        setTextAttribute(bottomText)
        
        // if edit / details screen
        if let meme = meme {
            bottomText.text = meme.bottomText
            topText.text = meme.topText
            mainImage.contentMode = UIViewContentMode.ScaleAspectFit
            mainImage.image = meme.originalImage
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBar = tabBarController?.tabBar {
            tabBar.hidden = true
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBar = tabBarController?.tabBar {
            tabBar.hidden = false
        }
    }
    
    func setTextAttribute(text : UITextField) {
        text.enabled = false
        text.defaultTextAttributes = memeTextAttributes
        text.textAlignment = NSTextAlignment.Center
    }

    @IBAction func doneView(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
