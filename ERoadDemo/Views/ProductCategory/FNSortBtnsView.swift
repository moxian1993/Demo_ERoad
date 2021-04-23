//
//  FNSortBtnsView.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/22.
//

import UIKit

class FNSortBtnsView: UIView {
    
    var volumeBtnDidClickedClosure: ((UIButton) -> ())?
    var sortedBtnDidClickedClosure: ((UIButton) -> ())?
    var brandBtnDidClickedClosure: ((UIButton) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(volumeBtn)
        addSubview(sortedBtn)
        addSubview(brandBtn)
        
        let btns = [volumeBtn, sortedBtn, brandBtn]

        btns.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
        }
        btns.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 1)
        
        volumeBtn.addTarget(self, action: #selector(volumeBtnDidClicked(_:)), for: .touchUpInside)
        sortedBtn.addTarget(self, action: #selector(sortedBtnDidClicked(_:)), for: .touchUpInside)
        brandBtn.addTarget(self, action: #selector(brandBtnDidClicked(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - action
    @objc private func volumeBtnDidClicked(_ sender: UIButton) {
        print(#function)
        if let closure = volumeBtnDidClickedClosure {
            closure(sender)
        }
    }

    @objc private func sortedBtnDidClicked(_ sender: UIButton) {
        print(#function)
        if let closure = sortedBtnDidClickedClosure {
            closure(sender)
        }
    }
    
    @objc private func brandBtnDidClicked(_ sender: UIButton) {
        print(#function)
        if let closure = brandBtnDidClickedClosure {
            closure(sender)
        }
    }
    
    
    // 销量btn
    private lazy var volumeBtn: UIButton = {
        return createBtn(title: fn_string(key: "salesVolume"))
    }()
    // 价格btn
    private lazy var sortedBtn = FNSortedBtn()
    // 品牌btn
    private lazy var brandBtn: UIButton = {
        return createBtn(title: fn_string(key: "brand"))
    }()
    
    private func createBtn(title: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(grayTextColor, for: .normal)
        btn.setTitleColor(selectedColor, for: .highlighted)
        btn.setTitleColor(selectedColor, for: .selected)
        btn.backgroundColor = categoryColor
        btn.titleLabel?.textAlignment = .center
        return btn
    }
}


class FNSortedBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(leftLine)
        addSubview(rightLine)

        leftLine.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.left.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(6)
        }

        rightLine.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.right.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(6)
        }
        
        addSubview(lab)
        addSubview(topIcon)
        addSubview(bottomIcon)
        
        let labWidth = (fn_string(key: "price") as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]).width
        let margin: CGFloat  = 5
        let iconWidth: CGFloat = 12

        let offset = (labWidth + margin + iconWidth) / 2.0 - labWidth
        lab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-0.5)
            make.centerX.equalTo(self.snp.centerX).offset(offset)
        }
        
        topIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(iconWidth)
            make.left.equalTo(lab.snp.right).offset(margin)
            make.centerY.equalTo(lab).offset(-3)
        }

        bottomIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(iconWidth)
            make.left.equalTo(topIcon)
            make.centerY.equalTo(lab).offset(3)
        }
    }
    
    private lazy var lab: UILabel = {
        let lab = UILabel()
        lab.textColor = grayTextColor
        lab.text = fn_string(key: "price")
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    private lazy var topIcon: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "triangle"))
        return imgView
    }()
    
    private lazy var bottomIcon: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "triangle"))
        imgView.transform = transform.rotated(by: .pi)
        return imgView
    }()
    
    private lazy var leftLine: UIView = drawLine(grayTextColor)
    private lazy var rightLine: UIView = drawLine(grayTextColor)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var isSelected: Bool {
        didSet {
            
        }
    }
}
