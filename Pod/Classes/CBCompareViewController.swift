//
//  CBCompareViewController.swift
//
//  Created by Casey Brumbaugh on 3/21/15.
//  Copyright (c) 2015 Casey Brumbaugh. All rights reserved.
//

import UIKit

public class CBCompareViewController: UIViewController {
    
    // View Controllers
    private var leftViewController: UIViewController?
    private var centerViewController: UIViewController?
    private var rightViewController: UIViewController?
    
    // View Constraints
    private var leftViewConstraint: NSLayoutConstraint?
    private var centerViewConstraint: NSLayoutConstraint?
    private var rightViewConstraint: NSLayoutConstraint?
    
    // Movement tracking
    private var leftViewConstraintLastValue: CGFloat = 0
    private var centerViewConstraintLastValue: CGFloat = 0
    private var rightViewConstraintLastValue: CGFloat = 0
    
    // Misc
    private var panGestureStartPoint: CGPoint?
    
    // MARK: - Lifecycle
    
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // Hide drop shadows due to the delay in animation
        hideDropShadow(leftViewController!.view)
        hideDropShadow(rightViewController!.view)
        
        // create rect for shadow after rotation
        // view's current size cannot be used since
        // it may not be the same after rotation
        var shadowRect = CGRectZero
        shadowRect.size = size
        
        // Animate with the rotation
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.snapViews()
            
        }, completion: { (context) -> Void in
            
            // redraw drop shadow on left view
            if let leftViewController = self.leftViewController {
                self.addDropShadow(leftViewController.view, shadowRect: shadowRect)
            }
            
            // redraw drop shadow on right view
            if let rightViewController = self.rightViewController {
                self.addDropShadow(rightViewController.view, shadowRect: shadowRect)
            }
            
        })
        
    }

    // MARK: - Configuration
    
    /**
    Sets up the left, center, and right view controllers
    */
    public func configureWithControllers(leftViewController: UIViewController,
        centerViewController: UIViewController,
        rightViewController: UIViewController) {
            
            // Hold on to view controllers
            self.leftViewController = leftViewController
            self.centerViewController = centerViewController
            self.rightViewController = rightViewController
            
            // Configure the view
            configureView()
    }
    
    /**
    Add the specified controller as a child view controller
    Also add its view and set up autolayout constraints
    */
    private func addChildController(viewController: UIViewController) -> NSLayoutConstraint? {
        
        // Degine Layout Constraint to return
        var leadingHorizontalConstraint: NSLayoutConstraint?
        
        // Make sure view is not nil
        if let viewToAdd = viewController.view {
            
            // Add the container view
            view.addSubview(viewToAdd)
            
            // Prepare view for constraints
            viewToAdd.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            // build constraints, keep height and width the same as container view
            let views = ["viewToAdd": viewToAdd, "container": view]
            
            // Define Visual Format Language for constraints
            let horizontalVFL = "H:|-0-[viewToAdd(container)]"
            let verticalVFL = "V:|-0-[viewToAdd(container)]"
            
            // Generate constraints form Visual Format Language
            var horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(horizontalVFL, options: nil, metrics: nil, views: views)
            var verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(verticalVFL, options: nil, metrics: nil, views: views)
            
            // Get a hook on the constraint to pass back
            for constraint in horizontalConstraints {
                if let constraint = constraint as? NSLayoutConstraint {
                    if constraint.firstAttribute == NSLayoutAttribute.Leading && constraint.secondAttribute == NSLayoutAttribute.Leading {
                        leadingHorizontalConstraint = constraint
                    }
                }
            }
            
            // Add generated constraints
            view.addConstraints(horizontalConstraints)
            view.addConstraints(verticalConstraints)
            view.setNeedsUpdateConstraints()
            
            // Register controller as a child controller
            addChildViewController(viewController)
            viewController.didMoveToParentViewController(self)
            viewController.view.setNeedsLayout()
        }
        
        // Do not return a constraint since no view was added
        return leadingHorizontalConstraint
    }
    
    /**
    Configures the view by placing child views
    */
    private func configureView() {
        
        // Set as black so the background color on the left and 
        // right views will be faded to black as the become hidden
        view.backgroundColor = UIColor.blackColor()
        
        // Configure center child controller
        if let centerViewController = centerViewController {
            centerViewConstraint = addChildController(centerViewController)
            centerViewConstraintLastValue = centerViewConstraint!.constant
        }
        
        // Configure left child controller
        if let leftViewController = leftViewController {
            leftViewConstraint = addChildController(leftViewController)
            leftViewConstraint?.constant -= view.bounds.size.width * 0.75
            leftViewConstraintLastValue = leftViewConstraint!.constant
            addDropShadow(leftViewController.view)
        }
        
        // Configure right child controller
        if let rightViewController = rightViewController {
            rightViewConstraint = addChildController(rightViewController)
            rightViewConstraint?.constant += view.bounds.size.width * 0.75
            rightViewConstraintLastValue = rightViewConstraint!.constant
            addDropShadow(rightViewController.view)
        }
        
        // Add Gesture to allow user interaciton
        addGestures()
    }

    // MARK: - Drop Shadow
    
    /**
    Adds a drop shadow around the view passed in
    If no shadowRect is passed in, shadow is added to the view's bounds
    */
    private func addDropShadow(view: UIView) {
        addDropShadow(view, shadowRect: view.bounds)
    }
    
    /**
    Adds a drop shadow around the view passed in
    If no shadowRect is passed in, shadow is added to the view's bounds
    */
    private func addDropShadow(view: UIView, shadowRect: CGRect) {
        
        view.layer.shadowPath = nil
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        view.layer.shadowOpacity = 0.8
        var shadowPath = UIBezierPath(rect: shadowRect)
        view.layer.shadowPath = shadowPath.CGPath
    }
    
    /**
    Hides the drop shadow on the passed in view
    */
    private func hideDropShadow(view: UIView) {
        view.layer.shadowOpacity = 0.0
    }
    
    // MARK: - Gestures
    
    /**
    Adds gestures to allow the user to interact
    */
    private func addGestures() {
        
        // Add pan gesture to allow horizontal reveals of the left and right child controllers
        let panGestureRegognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        view.addGestureRecognizer(panGestureRegognizer)
    }
    
    /**
    Responds to events form the pan gesture recognizer
    */
    internal func handlePan(panGesture: UIPanGestureRecognizer) {
        
        // Determine state of gesture
        switch panGesture.state {
            
        case .Began:
            
            // Keep track of starting point so gesture direction can later be determined
            panGestureStartPoint = panGesture.locationInView(view)
            break
            
        case .Changed:
            
            // Get the distance traveled by the user
            var move:CGFloat = panGesture.locationInView(view).x - panGestureStartPoint!.x
            
            // Adjust the constraints for each of the child view controllers
            var leftConstant = leftViewConstraintLastValue + move
            var centerConstant = centerViewConstraintLastValue + (move * CGFloat(0.5))
            var rightConstant = rightViewConstraintLastValue + move
            
            // Don't let the scrolling go beyond the left edge of the left child controller
            if leftConstant >= 0 {
                leftConstant = 0
                centerConstant = view.bounds.width
                rightConstant = view.bounds.width
            }
            
            // Don't let the scrolling go beyond the right edge of the right child controller
            if rightConstant <= 0 {
                rightConstant = 0
                centerConstant = 0 - view.bounds.width
                leftConstant = 0 - view.bounds.width
            }
            
            // Make updates to the final calculated constraints
            leftViewConstraint?.constant = leftConstant
            centerViewConstraint?.constant = centerConstant
            rightViewConstraint?.constant = rightConstant
            
            break
            
        default:
            
            // Reset the gesture start point
            panGestureStartPoint = nil

            // Snap the views into place if necessary
            snapViews()

        }
    }
    
    // MARK: - Scrolling and Snap
    
    /**
    Centers either the left, center, or right child view in the viewport
    */
    private func snapViews() {
        
        // Snap into place based on the positioning of the center view
        if centerViewConstraint!.constant > (view.bounds.width * 0.25) {
            
            // Snap left
            leftViewConstraint?.constant = 0
            centerViewConstraint?.constant = view.bounds.width/2
            rightViewConstraint?.constant = view.bounds.width * 1.5
        } else if centerViewConstraint!.constant < (0 - view.bounds.width * 0.25) {
            
            // Snap right
            leftViewConstraint?.constant = 0 - view.bounds.width * 1.5
            centerViewConstraint?.constant = 0 - view.bounds.width/2
            rightViewConstraint?.constant = 0
        } else {
            
            // Snap center
            leftViewConstraint?.constant = 0 - view.bounds.width * 0.75
            centerViewConstraint?.constant = 0
            rightViewConstraint?.constant = view.bounds.width * 0.75
        }
        
        // Animate snapping into place
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        // Save the updated constraints
        leftViewConstraintLastValue = leftViewConstraint!.constant
        centerViewConstraintLastValue = centerViewConstraint!.constant
        rightViewConstraintLastValue = rightViewConstraint!.constant
    }

}

