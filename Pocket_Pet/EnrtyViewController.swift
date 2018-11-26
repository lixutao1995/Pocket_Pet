//
//  EnrtyViewController.swift
//  Pocket_Pet
//
//  Created by Leiquan Pan on 11/24/18.
//  Copyright © 2018 Leiquan Pan. All rights reserved.
//

import UIKit

class EnrtyViewController: UIViewController {

    @IBOutlet weak var AppIcon: UIImageView!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //button bound
        continueButton.layer.masksToBounds = true
        continueButton.layer.cornerRadius = 10
        
        //set app icon image
//        AppIcon.image =
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toARkitView", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
