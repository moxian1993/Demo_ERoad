//
//  FNToastManager.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/25.
//

import Foundation
import Toast_Swift

class FNToastManager {
    
    class func config() {
        
        var style = ToastStyle()
        style.activityBackgroundColor = UIColor.clear
        style.activityIndicatorColor = UIColor.lightGray
        
        ToastManager.shared.style = style
    }
    
    class func show() {
        keyWindow?.addSubview(clearView)
        clearView.makeToastActivity(.center)
    }
    
    class func hide() {
        clearView.hideToastActivity()
    }
    
    static let clearView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        return v
    }()
}
