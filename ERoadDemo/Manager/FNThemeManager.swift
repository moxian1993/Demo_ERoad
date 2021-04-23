//
//  FNThemeManager.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/14.
//

import UIKit

class FNThemeManager: NSObject {
    
    class func image(named: String) -> UIImage? {
        return UIImage(named: named)
    }
    
    class func localizedString(key: String) -> String {
        return Bundle.main.localizedString(forKey: key, value: "", table: "FNLocalizedString")
    }
    
}
