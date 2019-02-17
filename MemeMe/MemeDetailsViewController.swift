//
//  MemeDetailsViewController.swift
//  MemeMe
//
//  Created by Baraa Hesham on 2/15/19.
//  Copyright © 2019 Baraa Hesham. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {

    @IBOutlet weak var memeDetailsImage: UIImageView!
    var meme:Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        self.memeDetailsImage!.image = self.meme.memedImage
        self.tabBarController?.tabBar.isHidden = true

    }
    



}
