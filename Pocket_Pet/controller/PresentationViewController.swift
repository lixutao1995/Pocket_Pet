//
//  PresentationViewController.swift
//  Pocket_Pet
//
//  Created by Xutao Li on 29/11/18.
//

import UIKit

class PresentationViewController: UIPresentationController {
    private lazy var cover:UIView=UIView()
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        let window = UIApplication.shared.keyWindow
        presentedView?.frame=CGRect(x: 0, y: (window?.frame.height)!*5/6, width: (window?.frame.width)!, height: (window?.frame.height)!/6)
//        presentedView?.frame=CGRect(x: 100, y: 55, width: 100, height: 100)
        setupCover()
    }
}
extension PresentationViewController{
    private func setupCover(){
        containerView?.insertSubview(cover, at: 0)
        
        cover.backgroundColor=UIColor(white: 0.5, alpha: 0.1)
        cover.frame=(containerView!.bounds)
        let tap=UITapGestureRecognizer(target: self, action: "click")
        cover.addGestureRecognizer(tap)
    }
    
    @objc private func click(){
//        print("click")
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
