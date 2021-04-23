//
//  ColorSuger.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/15.
//

import Foundation
import UIKit

/**
* Create UIColor Object.
* Color argument can be:
   1) UIColor object
   2) UIImage object, return a pattern image color
   3) "red", "green", "blue", "clear", etc. (any system color)
   5) "random": randomColor
   6) "255,0,0": RGB color
   7) "#FF0000" or "0xF00": Hex color
* All the string representation can have an optional alpha value.
* Usages:
   Color([UIColor redColor])
   Color("red")
   Color("red,0.1")        //with alpha
   Color("255,0,0)
   Color("255,0,0,1")      //with alpha
   Color("#FF0000")
   Color("#F00,0.1")       //with alpha
   Color("random,0.5")
   Color(Img("image"))     //using image
   ...
*/
public func _Color(_ obj: Any?) -> UIColor? {
    // type: nil color image string
    if obj == nil {
        return nil
    }
    
    if let color = obj as? UIColor {
        return color
    }
    
    if let image = obj as? UIImage {
        return UIColor(patternImage: image)
    }
    
    guard obj is String else {
        return nil
    }
    
    var alpha: CGFloat = 1
    var components = (obj as! String).components(separatedBy: ",")
    
    if components.count == 2 || components.count == 4 {
        alpha = min(CGFloat(Float(components.last!) ?? 1), 1)
        components.removeLast()
    }
    
    var r: Int?, g: Int?, b: Int?
    
    if components.count == 1 {
        let string = components.first!
        let sel = NSSelectorFromString(string + "Color")
        
        // try systemColor
        if UIColor.responds(to: sel) {
            let color = UIColor.perform(sel)?.takeRetainedValue() as? UIColor
            return (alpha == 1 ? color : color?.withAlphaComponent(alpha))
        }
        
        // random
        if string == "random" {
            r = Int(arc4random_uniform(256))
            g = Int(arc4random_uniform(256))
            b = Int(arc4random_uniform(256))
        }
        else if string.hasPrefix("#")  {
            if string._length() == 4 { // #FFF
                r = Int(string._subAt(1), radix:16)! * 17
                g = Int(string._subAt(2), radix:16)! * 17
                b = Int(string._subAt(3), radix:16)! * 17
                
            } else if string._length() == 7 { // #FFFFFF
                r = Int(string._subAt(1...2), radix:16)
                g = Int(string._subAt(3...4), radix:16)
                b = Int(string._subAt(5...6), radix:16)
            }
        }
        
    } else if components.count == 3 {
        r = Int(components[0])
        g = Int(components[1])
        b = Int(components[2])
    }
    
    if r != nil && g != nil && b != nil {
        return UIColor(red: CGFloat(r!) / 255.0,
                       green: CGFloat(g!) / 255.0,
                       blue: CGFloat(b!) / 255.0,
                       alpha: alpha)
    }
    return nil
}
