//
//  FNGoodsDetailCell.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/22.
//

import UIKit

class FNGoodsDetailCell: UITableViewCell {
    
    var viewModel: FNGoodsDetailInfoVM? {
        didSet {
            guard let vm = viewModel else { return }
            if let url = URL(string: vm.imgURLString) {
                imgView.kf.setImage(with: url)
            }
            tipsLab.isHidden = vm.isTipsHidden
            
            nameLab.text = vm.name
            firstVolumeLab.text = vm.spec
            
            // 是否要隐藏第二容量
            secondVolumeLab.isHidden = vm.isSecondLabShouldHidden
            line.isHidden = vm.isSecondLabShouldHidden
            if !vm.isSecondLabShouldHidden {
                secondVolumeLab.text = vm.box_spec
            } else {
                // 删掉 width 约束
                firstVolumeLab.snp.remakeConstraints { (make) in
                    make.top.equalTo(nameLab.snp.bottom).offset(6)
                    make.left.equalTo(nameLab)
                }
            }
            
            // 是否要显示活动标签
            boomLab.isHidden = vm.isBoomLabShouldHidden
            if !vm.isBoomLabShouldHidden {
                boomLab.text = vm.boomName
                boomLab.textColor = vm.boomTextColor
                boomLab.backgroundColor = vm.boomBgColor
                boomLab.layer.borderColor = vm.boomBorderColor
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    private func setup() {
        
        self.selectionStyle = .none
        
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.top.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10).priority(.low)
        }
    
        imgView.addSubview(tipsLab)
        tipsLab.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(5)
            make.width.height.equalTo(30)
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(imgView)
            make.left.equalTo(imgView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(firstVolumeLab)
        firstVolumeLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom).offset(6)
            make.left.equalTo(nameLab)
            make.width.lessThanOrEqualTo(80)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.height.equalTo(firstVolumeLab)
            make.left.equalTo(firstVolumeLab.snp.right).offset(10)
            make.width.equalTo(1)
        }
        
        contentView.addSubview(secondVolumeLab)
        secondVolumeLab.snp.makeConstraints { (make) in
            make.top.equalTo(firstVolumeLab)
            make.left.equalTo(line.snp.right).offset(5)
        }
        
        contentView.addSubview(boomLab)
        boomLab.snp.makeConstraints { (make) in
            make.left.equalTo(firstVolumeLab)
            make.top.equalTo(firstVolumeLab.snp.bottom).offset(6)
            make.height.equalTo(14)
        }

        contentView.addSubview(nowPriceLab)
        nowPriceLab.snp.makeConstraints { (make) in
            make.left.equalTo(firstVolumeLab)
            make.bottom.equalToSuperview().offset(-10)
        }

        contentView.addSubview(normalPriceLab)
        normalPriceLab.snp.makeConstraints { (make) in
            make.left.equalTo(nowPriceLab)
            make.bottom.equalTo(nowPriceLab.snp.top).offset(-1)
        }
        
        contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(1)
        }
    }
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    lazy var tipsLab: UILabel = {
        let lab = UILabel()
        lab.text = " 促销 "
        lab.textAlignment = .center
        lab.font = UIFont.boldSystemFont(ofSize: 12)
        lab.textColor = UIColor.red
        lab.backgroundColor = UIColor.yellow
        lab.layer.cornerRadius = 15
        lab.layer.masksToBounds = true
        lab.layer.borderColor = UIColor.red.cgColor
        lab.layer.borderWidth = 1
        return lab
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.textColor = grayTextColor
        lab.lineBreakMode = .byTruncatingTail
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var firstVolumeLab: UILabel = {
        let lab = UILabel()
        lab.textColor = lightGrayTextColor
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    lazy var line: UIView = drawLine(lightGrayTextColor)
    
    lazy var secondVolumeLab: UILabel = {
        let lab = UILabel()
        lab.textColor = lightGrayTextColor
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    lazy var boomLab: UILabel = {
        let lab = UILabel()
        lab.textColor = selectedColor
        lab.font = UIFont.systemFont(ofSize: 10)
        lab.layer.cornerRadius = 2
        lab.layer.masksToBounds = true
        lab.layer.borderWidth = 1
        return lab
    }()
    
    lazy var normalPriceLab: UILabel = {
        let lab = UILabel()
        let attributes: [NSAttributedString.Key : Any]
            = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9),
               NSAttributedString.Key.foregroundColor: lightGrayTextColor,
               NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        lab.attributedText = NSAttributedString(string: "￥***", attributes: attributes)
        return lab
    }()
    
    lazy var nowPriceLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 11)
        lab.textColor = selectedColor
        lab.text = "￥***"
        return lab
    }()
    
    lazy var separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = categoryColor
        return v
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
