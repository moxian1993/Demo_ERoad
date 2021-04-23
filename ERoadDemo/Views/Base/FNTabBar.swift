//
//  FNTabBar.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/15.
//

import UIKit

class FNTabBar: UITabBar {
    
    let width = UIScreen.main.bounds.size.width / 5.0

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var num: CGFloat = 0
        subviews.filter { $0.isKind(of: NSClassFromString("UITabBarButton")!) }.forEach {
            $0.frame = CGRect(x: num*width, y: 0, width: width, height: $0.bounds.height)
            if num == 1 {
                num += 1
            }
            num += 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "tabbar_scanning"), for: .normal)
        btn.backgroundColor = UIColor.red
        addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        let indent: CGFloat = 2.5
        btn.imageEdgeInsets = UIEdgeInsets(top: indent, left: indent, bottom: indent, right: indent)
        
        btn.addTarget(self, action: #selector(self.scanBtnDidClicked(_:)), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - action
    @objc private func scanBtnDidClicked(_ sender: UIButton) {
        print(#function)
    }
    
}
