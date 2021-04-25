//
//  FNVerticalButton.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/20.
//

import UIKit
import SDWebImage

class FNVerticalButton: UIControl {
    
    var ob: NSKeyValueObservation?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        isUserInteractionEnabled = false
        
        ob = observe((\.isSelected), options: [.new]) { (_, change) in
            self.updateUI(isSelected: change.newValue ?? false)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func updateUI(isSelected: Bool) {
        lab.textColor = isSelected ? selectedColor : lightGrayTextColor
        imgView.layer.borderColor = isSelected ? selectedColor.cgColor : categoryColor.cgColor
    }

    private lazy var lab: UILabel = {
        let lab = UILabel()
        lab.textColor = lightGrayTextColor
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 20
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = categoryColor.cgColor
        return imgView
    }()

    
    var viewModel: FNGoodsCategoryVM? {
        didSet {
            guard let vm = viewModel else { return }
            lab.text = vm.model.cate_name
            if let url = URL(string: vm.pngImgURLString)  {
                let options: SDWebImageOptions = [.scaleDownLargeImages, .avoidDecodeImage]
                imgView.sd_setImage(with: url, placeholderImage: nil, options: options, context: nil)
            }
        }
    }
}
