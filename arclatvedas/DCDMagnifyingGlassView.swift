//
//  DCDMagnifyingGlassView.swift
//  DCDMagnifyingGlass
//
//  Created by David Dong on 2015-04-01.
//  Copyright (c) 2015 David Dong.
//  https://github.com/c9dong/DCDMagnifyingGlassView

import Foundation
import UIKit

private let _DCDMagnifyingGlassViewInstance: DCDMagnifyingGlassView = DCDMagnifyingGlassView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))

protocol DCDMagnifyingGlassViewDelegate: NSObjectProtocol {
    func managePanBegin(_ sender: UIPanGestureRecognizer)
    func managePanEnd(_ sender: UIPanGestureRecognizer)
}

final class DCDMagnifyingGlassView: UIView {
    
    // MARK: Singleton variable
    class var sharedInstance: DCDMagnifyingGlassView {
        return _DCDMagnifyingGlassViewInstance
    }
    
    // MARK: Properties
    let plusView: ReticuleView = ReticuleView()
    let glassView: UIView = UIView()
    let magnifyingImageView: UIImageView = UIImageView()
    let indicatorView: UIView = UIView()
    let shadowLayer: CAShapeLayer = CAShapeLayer()
    let panGestureRecognizer = UIPanGestureRecognizer()
    
    // Scene-aware, safer default target view
    var targetView: UIView = DCDMagnifyingGlassView.findDefaultTargetView() ?? UIView()
    var scale: CGFloat = 2
    var glassDelegate: DCDMagnifyingGlassViewDelegate?
    
    // MARK: Constructors
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private static func findDefaultTargetView() -> UIView? {
        // Collect all window scenes
        let scenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
        
        // Prefer the key window of the active foreground scene
        if let activeScene = scenes.first(where: { $0.activationState == .foregroundActive }) {
            if let keyWindow = activeScene.windows.first(where: { $0.isKeyWindow }) {
                return keyWindow
            }
            // If no key window, fall back to any window in the active scene
            if let anyWindow = activeScene.windows.first {
                return anyWindow
            }
        }
        
        // Fallback: any key window across all scenes
        let allWindows = scenes.flatMap { $0.windows }
        if let keyWindow = allWindows.first(where: { $0.isKeyWindow }) {
            return keyWindow
        }
        if let anyWindow = allWindows.first {
            return anyWindow
        }
        
        // Legacy fallback: AppDelegate.window if present (pre-multi-scene apps)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let window = appDelegate.window {
            return window
        }
        
        return nil
    }
    
    func setupViews() {
        // Set up the indicator
        indicatorView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/scale, height: self.frame.size.height/scale)
        indicatorView.layer.borderColor = UIColor.lightGray.cgColor
        indicatorView.layer.borderWidth = 2
        indicatorView.layer.cornerRadius = indicatorView.frame.size.width/2
        indicatorView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(indicatorView)
        
        // Set up the glass
        let glassY = indicatorView.frame.origin.y - 10 - self.frame.size.height
        glassView.frame = CGRect(x: 0, y: glassY, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(glassView)
        
        // Add shadow layer
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.7
        shadowLayer.shadowOffset = CGSize(width: 0, height: 3)
        glassView.layer.addSublayer(shadowLayer)
        
        // Set up the image display
        magnifyingImageView.frame = CGRect(x: 0, y: 0, width: glassView.frame.size.width, height: glassView.frame.size.height)
        magnifyingImageView.contentMode = UIView.ContentMode.scaleToFill
        magnifyingImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        magnifyingImageView.clipsToBounds = true
        glassView.addSubview(magnifyingImageView)
        
        plusView.frame = CGRect(x: 0, y: 0, width: glassView.frame.size.width, height: glassView.frame.size.height)
        plusView.contentMode = UIView.ContentMode.scaleToFill
        plusView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        plusView.clipsToBounds = true
        glassView.addSubview(plusView)
        
        // Set up gesture recognizer
        panGestureRecognizer.addTarget(self, action: #selector(DCDMagnifyingGlassView.panAction(_:)))
        indicatorView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.isEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSubviews(false)
    }
    
    func layoutSubviews(_ animated: Bool) {
        let cornerRadius: CGFloat = CGFloat(max(frame.size.width, frame.size.height)/2)
        magnifyingImageView.layer.borderColor = UIColor.gray.cgColor
        magnifyingImageView.layer.cornerRadius = CGFloat(cornerRadius)
        
        // Update the indicator frame
        let indicatorSize = max(min(self.frame.size.width/scale, 50), 10)
        indicatorView.frame = CGRect(x: 0, y: 0, width: indicatorSize, height: indicatorSize)
        indicatorView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        indicatorView.layer.cornerRadius = indicatorView.frame.size.width/2
        
        // Update the frame of the glass
        if panGestureRecognizer.isEnabled {
            var glassY = indicatorView.frame.origin.y - 10 - self.frame.size.height
            if indicatorView.center.y > self.center.y - 50 {
                glassY = indicatorView.frame.origin.y + 10 + self.frame.size.height/2
            }
            
            if animated {
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               options: UIView.AnimationOptions(),
                               animations: { () -> Void in
                                   self.glassView.frame = CGRect(x: 0, y: glassY, width: self.frame.size.width, height: self.frame.size.height)
                                   self.indicatorView.alpha = 1
                               }, completion: nil)
            } else {
                glassView.frame = CGRect(x: 0, y: glassY, width: self.frame.size.width, height: self.frame.size.height)
                self.indicatorView.alpha = 1
            }
            refreshImage()
        } else {
            if animated {
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               options: UIView.AnimationOptions(),
                               animations: { () -> Void in
                                   self.glassView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
                                   self.indicatorView.alpha = 0
                               }, completion: nil)
            } else {
                glassView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
                self.indicatorView.alpha = 0
            }
        }
        refreshImage()
        
        // Update the shadow of the view
        let shadowPath = UIBezierPath(roundedRect: magnifyingImageView.frame, cornerRadius: cornerRadius)
        shadowLayer.shadowPath = shadowPath.cgPath
    }
    
    // MARK: Helper functions
    fileprivate func moveView(_ translation: CGPoint) {
        self.frame = CGRect(x: self.frame.origin.x + translation.x, y: self.frame.origin.y + translation.y, width: self.frame.size.width, height: self.frame.size.height)
        self.layoutSubviews(false)
    }
    
    fileprivate func snapshotTargetView(_ view: UIView!, inRect rect: CGRect!) -> UIImage! {
        // Hide self
        self.isHidden = true
        
        let scale = UIScreen.main.scale
        
        // Snapshot of view
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        UIGraphicsGetCurrentContext()?.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        view.layer.render(in: UIGraphicsGetCurrentContext()!) // Need this to stop screen flashing, but it's slower
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show self
        self.isHidden = false
        
        return snapshotImage
    }
    
    fileprivate func resizeImage(_ image: UIImage, toNewSize newSize: CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // MARK: Refresh
    func refreshImage() {
        // Ensure targetView is valid; re-resolve if needed
        if targetView.window == nil, let resolved = DCDMagnifyingGlassView.findDefaultTargetView() {
            targetView = resolved
        }
        
        // Since we are scaling the image, we can take a snapshot of a smaller image instead, thus increasing performance
        let newWidth = self.frame.size.width / scale
        let newHeight = self.frame.size.height / scale
        let newX = (self.frame.size.width - newWidth) / 2 + self.frame.origin.x
        let newY = (self.frame.size.height - newHeight) / 2 + self.frame.origin.y
        var newImage = snapshotTargetView(targetView, inRect: CGRect(x: newX, y: newY, width: newWidth, height: newHeight))
        newImage = resizeImage(newImage!, toNewSize: self.frame.size)
        magnifyingImageView.image = newImage
    }
    
    // MARK: Gesture Actions
    @objc func panAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case UIGestureRecognizer.State.began:
            glassDelegate?.managePanBegin(sender)
        case UIGestureRecognizer.State.changed:
            let translation = sender.translation(in: targetView)
            moveView(translation)
            sender.setTranslation(.zero, in: targetView)
        case UIGestureRecognizer.State.ended, UIGestureRecognizer.State.failed, UIGestureRecognizer.State.cancelled:
            sender.setTranslation(.zero, in: targetView)
            glassDelegate?.managePanEnd(sender)
        default:
            break
        }
    }
    
    // MARK: Hit Test
    func distanceFromPoint(_ point1: CGPoint, toPoint point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return sqrt(dx*dx + dy*dy)
    }
    
    // Convert touch space into a circle instead of a rectangle
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let radius = self.bounds.size.width/2
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        let dist = distanceFromPoint(point, toPoint: center)
        if dist <= radius {
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
    // MARK: Set Properties
    class func setTargetView(_ targetView: UIView) {
        DCDMagnifyingGlassView.sharedInstance.targetView = targetView
    }
    
    class func setScale(_ scale: CGFloat) {
        DCDMagnifyingGlassView.sharedInstance.scale = scale
    }
    
    class func allowDragging(_ allowDragging: Bool, animated: Bool) {
        DCDMagnifyingGlassView.sharedInstance.panGestureRecognizer.isEnabled = allowDragging
        DCDMagnifyingGlassView.sharedInstance.layoutSubviews(animated)
    }
    
    class func setContentFrame(_ frame: CGRect) {
        var correctedFrame = frame
        var width = frame.size.width
        var height = frame.size.height
        if width != height {
            width = min(width, height)
            height = width
            correctedFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
        }
        DCDMagnifyingGlassView.sharedInstance.frame = correctedFrame
    }
    
    class func setIndicatorColor(_ color: UIColor) {
        DCDMagnifyingGlassView.sharedInstance.indicatorView.layer.borderColor = color.cgColor
    }
    
    class func setShadowColor(_ color: UIColor) {
        DCDMagnifyingGlassView.sharedInstance.shadowLayer.shadowColor = color.cgColor
    }
    
    // MARK: Show/Dismiss
    class func show(_ animated: Bool) {
        DCDMagnifyingGlassView.sharedInstance.layoutSubviews(false)
        // Re-resolve a valid target view when showing
        if let resolved = findDefaultTargetView() {
            DCDMagnifyingGlassView.sharedInstance.targetView = resolved
        }
        DCDMagnifyingGlassView.sharedInstance.targetView.addSubview(DCDMagnifyingGlassView.sharedInstance)
        if animated {
            DCDMagnifyingGlassView.sharedInstance.alpha = 0
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: UIView.AnimationOptions(),
                           animations: { () -> Void in
                               DCDMagnifyingGlassView.sharedInstance.alpha = 1
                           }, completion: nil)
        }
    }
    
    class func dismiss(_ animated: Bool) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: UIView.AnimationOptions(),
                       animations: { () -> Void in
                           DCDMagnifyingGlassView.sharedInstance.alpha = 0
                       }) { _ in
            DCDMagnifyingGlassView.sharedInstance.removeFromSuperview()
        }
    }
}
