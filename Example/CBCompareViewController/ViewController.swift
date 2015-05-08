//
//  ViewController.swift
//  CBCompareViewController
//
//  Created by Casey Brumbaugh on 4/29/15.
//  Copyright (c) 2015 Casey Brumbaugh. All rights reserved.
//

import UIKit
import CBCompare

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "embed" {
            
            if let vc = segue.destinationViewController as? CBCompareViewController {
                
                let l = UIViewController()
                let c = UIViewController()
                let r = UIViewController()
                
                l.view.backgroundColor = UIColor.blueColor()
                c.view.backgroundColor = UIColor.greenColor()
                r.view.backgroundColor = UIColor.redColor()
                
                let lImageView = UIImageView(image: UIImage(named: "mountain"))
                lImageView.contentMode = UIViewContentMode.ScaleAspectFill
                lImageView.clipsToBounds = true
                l.view.addSubview(lImageView)
                
                // Prepare view for constraints
                lImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                // build constraints
                var views = ["viewToAdd": lImageView, "container": l.view]
                var horizontalVFL = "H:|-0-[viewToAdd(container)]-0-|"
                var verticalVFL = "V:|-0-[viewToAdd(container)]-0-|"
                var horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(horizontalVFL, options: nil, metrics: nil, views: views)
                var verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(verticalVFL, options: nil, metrics: nil, views: views)
                l.view.setNeedsUpdateConstraints()
                
                // Add constraints
                l.view.addConstraints(horizontalConstraints)
                l.view.addConstraints(verticalConstraints)
                l.view.setNeedsUpdateConstraints()
                
                let cImageView = UIImageView(image: UIImage(named: "meadow"))
                cImageView.contentMode = UIViewContentMode.ScaleAspectFill
                cImageView.clipsToBounds = true
                c.view.addSubview(cImageView)
                
                // Prepare view for constraints
                cImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                // build constraints
                views = ["viewToAdd": cImageView, "container": c.view]
                horizontalVFL = "H:|-0-[viewToAdd(container)]-0-|"
                verticalVFL = "V:|-0-[viewToAdd(container)]-0-|"
                horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(horizontalVFL, options: nil, metrics: nil, views: views)
                verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(verticalVFL, options: nil, metrics: nil, views: views)
                
                // Add constraints
                c.view.addConstraints(horizontalConstraints)
                c.view.addConstraints(verticalConstraints)
                c.view.setNeedsUpdateConstraints()
                
                let rImageView = UIImageView(image: UIImage(named: "desert"))
                rImageView.contentMode = UIViewContentMode.ScaleAspectFill
                rImageView.clipsToBounds = true
                r.view.addSubview(rImageView)
                
                // Prepare view for constraints
                rImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                // build constraints
                views = ["viewToAdd": rImageView, "container": r.view]
                horizontalVFL = "H:|-0-[viewToAdd(container)]-0-|"
                verticalVFL = "V:|-0-[viewToAdd(container)]-0-|"
                horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(horizontalVFL, options: nil, metrics: nil, views: views)
                verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(verticalVFL, options: nil, metrics: nil, views: views)
                
                // Add constraints
                r.view.addConstraints(horizontalConstraints)
                r.view.addConstraints(verticalConstraints)
                r.view.setNeedsUpdateConstraints()
                
                // Configure threewayslider
                vc.configureWithControllers(l, centerViewController: c, rightViewController: r)
            }
        }
    }

}

