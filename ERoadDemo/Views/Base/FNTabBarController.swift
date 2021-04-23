//
//  FNTabBarController.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/14.
//

import UIKit

class FNTabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
        setValue(FNTabBar(), forKey: "tabBar")
        
        self.selectedIndex = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        ["Homepage", "All", "Addcart", "Me"].forEach { (name) in
            let proj = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""
            let clz = NSClassFromString("\(proj).FN\(name)Controller") as! FNBaseViewController.Type
            let vc = FNNaviController(rootViewController: clz.init())
            
            let imgName = "tabbar_\(name.lowercased())"
            vc.title = fn_string(key: name)
            let scaleSize: CGFloat = 32
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: scaleSize, left: scaleSize, bottom: scaleSize, right: scaleSize)
            vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
            vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
            vc.tabBarItem.image = fn_image(name: imgName)?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = fn_image(name: imgName)?.withTintColor(.red, renderingMode: .alwaysOriginal)
            addChild(vc)
        }
    }
}
