//
//  FNGoodsDetailInfoVM.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/23.
//

import Foundation


class FNGoodsDetailInfoVM {
    
    var model: Goods
    var name: String {
        return model.gname
    }
    
    var imgURLString: String {
        return model.imgurl
    }
    
    var spec: String {
        return model.spec
    }
    
    var box_spec: String {
        return model.box_spec
    }
    
    var isSecondLabShouldHidden: Bool {
        return box_spec.count == 0
    }
    
    var isBoomLabShouldHidden: Bool {
        return boomTags.count <= 0
    }
    
    var boomTags: [GoodsTags] {
        return model.tags
    }
    
    var boomName: String {
        return " \(boomTags.first?.name ?? "") "
    }
    
    var boomTextColor: UIColor {
        return _Color(boomTags.first?.color ?? "red")!
    }
    
    var boomBgColor: UIColor {
        return _Color(boomTags.first?.bgcolor ?? "white")!
    }
    
    var boomBorderColor: CGColor {
        return _Color(boomTags.first?.bordercolor ?? "red")!.cgColor
    }
    
    var isTipsHidden: Bool {
        return model.promotion_flag == "0"
    }
    
    
    init(model: Goods) {
        self.model = model
    }
}
