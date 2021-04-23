//
//  FNGoodsSubRightCell.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/22.
//

import UIKit

class FNGoodsSubRightCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = UIColor.white
        contentView.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var lab: UILabel = {
       let lab = UILabel()
        lab.textColor = grayTextColor
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.textAlignment = .center
        return lab
    }()
    
    override var isSelected: Bool {
        didSet {
            lab.textColor = isSelected ? selectedColor : grayTextColor
        }
    }
    
}
