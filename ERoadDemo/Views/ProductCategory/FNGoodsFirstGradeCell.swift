//
//  FNGoodsFirstGradeCell.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/19.
//

import UIKit
import SDWebImage

class FNGoodsFirstGradeCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            btn.isSelected = isSelected
        }
    }

    private lazy var btn: FNVerticalButton = {
        let btn = FNVerticalButton()
        return btn
    }()
    
    
    var viewModel: FNGoodsCategoryVM? {
        set {
            btn.viewModel = newValue
        }
        get {
            return btn.viewModel
        }
    }
    

}
