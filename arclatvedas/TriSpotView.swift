//
//  TriSpotView.swift
//  arclatvedas
//
//  Created by divol on 31/07/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit


class TriSpotView: BlasonView {
    
    override var nombrezone:Int {
        return 5
    }
    
    override var scores:[Int] {
        return [100,10,9,8,7,6]
    }
    
    
    override var colors:[UIColor] {
        return [UIColor.yellow,UIColor.yellow,UIColor.yellow,UIColor.red,UIColor.red,UIColor.blue]
    }
    
    override var colorslines:[UIColor] { return [UIColor.black,UIColor.black,UIColor.black,UIColor.black,UIColor.black,UIColor.black]}
    
    
    
   override func getScoreForPoint(_ point:CGPoint)->CGPoint{
        var result:CGPoint = CGPoint(x: 0,y: 0)
    
    for zone in 0 ..< 3{
        // trispot
    
        var x=nombrezone
        repeat {
            let circle = circles[zone][x]
            
            if circle.contains(point) {
                result.x = CGFloat(scores[nombrezone-x])
                result.y = CGFloat(zone);
                
                return result
                
            }
            x -= 1
        }while (x > -1)
     }
        return result
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    
    override func draw(_ rect: CGRect) {
        let pathck = UIBezierPath(rect: rect)
        UIColor.white.setFill()
        pathck.fill()
        
        
     //   var marge = 25/2 // voir TargetController
        
        
        let tinytaille = rect.size.width / 3
        let xx = (rect.size.width / 2) - (tinytaille / 2)
        for zone in 0 ..< 3{
            let spot = CGRect(x: xx ,y:  (CGFloat(zone) * tinytaille)   ,width: tinytaille-2, height:tinytaille-2)
            
            drawZone(spot, zone:zone)
        }
        
    }
    func drawZone(_ rect: CGRect, zone:Int) {
        // Drawing code
        
        
        
        let delta:CGFloat = (rect.size.width / CGFloat(2 * nombrezone))
        var inrect = rect
        var lastgoodrect = rect
        var x=nombrezone
        repeat {
            let path = UIBezierPath(ovalIn: inrect)
            if x !=  0{
                circles[zone].append(path)
            }
            colors[x].setFill()
            
            
            path.fill()
            
            colorslines[x].setStroke()
            path.lineWidth = 1.0
            path.stroke()
            
            x -= 1
            inrect = inrect.insetBy(dx: delta,dy: delta)
            if x == 1{
                lastgoodrect = inrect
            }
        }while (x > -1)
        
        // and the X !
        
        inrect = lastgoodrect.insetBy(dx: delta/2,dy: delta/2)
        if !inrect.isEmpty{
            let path = UIBezierPath(ovalIn: inrect)
            circles[zone].append(path)
            
            colorslines[0].setStroke()
            path.lineWidth = 1.0
            path.stroke()
            
        }
        
    }

    
}
