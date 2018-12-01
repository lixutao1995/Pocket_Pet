//
//  SettingViewController.swift
//  Pocket_Pet
//
//  Created by Xutao Li on 29/11/18.
//

import UIKit

class SettingViewController: UIViewController {
    var num:String?
    var temp:Double=0
    var red:Double=0
    var green:Double=0
    var blue:Double=0
    @IBAction func sizeSlider(_ sender: UISlider) {
        //get slider value
        num = String(format: "%.2f", sender.value)
        print(num)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
