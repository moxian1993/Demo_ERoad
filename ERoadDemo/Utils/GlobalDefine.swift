//
//  GlobalDefine.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/14.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit
import MJRefresh

let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }

// color
let categoryColor: UIColor = _Color("#DCDCDC") ?? UIColor.lightGray
let selectedColor: UIColor = _Color("#B22222") ?? UIColor.red
let lightGrayTextColor: UIColor = _Color("#808080") ?? UIColor.gray
let grayTextColor: UIColor = _Color("#696969") ?? UIColor.darkGray
let blackTextColor: UIColor = UIColor.black

// height
let statusBarHieght: CGFloat = {
    if #available(iOS 13.0, *) {
        let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
        return statusBarManager!.statusBarFrame.size.height
    } else {
        return UIApplication.shared.statusBarFrame.size.height
    }
}()


func fn_image(name: String) -> UIImage? {
    return FNThemeManager.image(named: name)
}

func fn_string(key: String) -> String {
    return FNThemeManager.localizedString(key: key)
}

func drawLine(_ color: UIColor) -> UIView {
    let line = UIView()
    line.backgroundColor = color
    return line
}


