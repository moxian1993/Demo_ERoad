//
//  FNGoodsCategoryVM.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/20.
//

import Foundation

class FNGoodsCategoryVM {
    
    var model: GoodsCategory
    
    var imgURLString: String {
        return model.img_url
    }
    
    var pngImgURLString: String {
        return imgURLString._subReplace(".webp", "")
    }
    
    var cateID: String {
        return model.cate_id
    }
    
    var cateName: String {
        return model.cate_name
    }
    
    init(model: GoodsCategory) {
        self.model = model
    }
}
