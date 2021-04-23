//
//  FNGoodsSubCell.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/21.
//

import UIKit

class FNGoodsSubCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = categoryColor
        contentView.backgroundColor = categoryColor
        
        textLabel?.numberOfLines = 0
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        contentView.addSubview(redLine)
        redLine.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(2)
        }
        redLine.isHidden = true
        
        contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
   
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        redLine.isHidden = !selected
        contentView.backgroundColor = selected ? _Color("white") : categoryColor
        textLabel?.textColor = selected ? selectedColor : grayTextColor
    }
    
    private lazy var redLine: UIView = {
        let v = UIView(frame: CGRect())
        v.backgroundColor = _Color("red")
        return v
    }()
    
    private lazy var separatorLine: UIView = {
        let v = UIView(frame: CGRect())
        v.backgroundColor = _Color("white")
        return v
    }()
    

}
