//
//  FNSortBtnsView.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/22.
//

import UIKit


enum FNBtnTag: Int {
    case volumnTag = 10, sortedTag, brandTag
}

class FNSortBtnsView: UIView {
    
    var volumeBtnDidClickedClosure: ((UIButton) -> ())?
    var sortedBtnDidClickedClosure: ((UIButton) -> ())?
    var brandBtnDidClickedClosure: ((UIButton) -> ())?
    
    var btns: [UIButton]?
    var selectedBtnTag: FNBtnTag = .volumnTag

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
        self.btns = btns
        
        volumeBtn.addTarget(self, action: #selector(btnDidClicked(_:)), for: .touchUpInside)
        sortedBtn.addTarget(self, action: #selector(btnDidClicked(_:)), for: .touchUpInside)
        brandBtn.addTarget(self, action: #selector(btnDidClicked(_:)), for: .touchUpInside)
        
        // 默认选中第一个
        volumeBtn.isSelected = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - action
    @objc private func btnDidClicked(_ sender: UIButton) {
        
        sender.isSelected = true
        selectedBtnTag = FNBtnTag(rawValue: sender.tag)!
        
        btns?.filter{ return FNBtnTag(rawValue: $0.tag) != selectedBtnTag }
            .forEach { $0.isSelected = false }
        
        switch selectedBtnTag {
        case .volumnTag:
            if let closure = volumeBtnDidClickedClosure {
                closure(sender)
            }
        case .sortedTag:
            if let closure = sortedBtnDidClickedClosure {
                closure(sender)
            }
        case .brandTag:
            if let closure = brandBtnDidClickedClosure {
                closure(sender)
            }
        }
    }
    
    
    // 销量btn
    private lazy var volumeBtn: UIButton = {
        return createBtn(title: fn_string(key: "salesVolume"), tag: .volumnTag)
    }()
    // 价格btn
    private lazy var sortedBtn = FNSortedBtn(tag: .sortedTag)
    // 品牌btn
    private lazy var brandBtn: UIButton = {
        return createBtn(title: fn_string(key: "brand"), tag: .brandTag)
    }()
    
    private func createBtn(title: String, tag: FNBtnTag) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(grayTextColor, for: .normal)
        btn.setTitleColor(selectedColor, for: .highlighted)
        btn.setTitleColor(selectedColor, for: .selected)
        btn.backgroundColor = categoryColor
        btn.titleLabel?.textAlignment = .center
        btn.tag = tag.rawValue
        return btn
    }
}


class FNSortedBtn: UIButton {
    
    var ascend: Bool = true
    let img = UIImage(named: "triangle")
    
    init(tag: FNBtnTag) {
        super.init(frame:CGRect())
        
        self.tag = tag.rawValue
        
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
        let imgView = UIImageView(image: img)
        return imgView
    }()
    
    private lazy var bottomIcon: UIImageView = {
        let imgView = UIImageView(image: img)
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
            lab.textColor = isSelected ? selectedColor : grayTextColor
            if isSelected {
                if ascend {
                    topIcon.image = topIcon.image?.withTintColor(selectedColor)
                    bottomIcon.image = img
                } else {
                    topIcon.image = img
                    bottomIcon.image = bottomIcon.image?.withTintColor(selectedColor)
                }
                ascend = !ascend
            } else {
                // 置为默认
                ascend = true
                topIcon.image = img
                bottomIcon.image = img
            }
        }
    }
}
