//
//  GoodsGradeModel.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/18.
//

import Foundation

struct GoodsFirstGradeModel: Codable {
    var area_id: Int
    var area_name: String
    var big_cate_name: String
    var big_cid: Int
    var categories: [GoodsCategory]
    var title: String
}

struct GoodsSubGradeModel: Codable {
    var current_cate_id: String
    var current_cate_name: String
    var categories: [GoodsCategory]
}

struct GoodsCategory: Codable {
    var cate_id: String
    var cate_name: String
    var have_child: Int
    var img_url: String
}



struct GoodsDetail: Codable {
    var list: [Goods]
    var sortInfo: [SortInfo]?
    var total: Int
    
    private enum CodingKeys : String , CodingKey {
        case list
        case sortInfo = "sort_info"
        case total
    }
}

struct SortInfo: Codable {
    var name: String
    var type: String
}

struct Goods: Codable {
    var barcode: String
    var box_spec: String
    var cid: Int
    var corner_icon: String
    var disp_remmain_qty: Int
    var frozen_icon: String
    var gname: String
    var imgurl: String
    var is_up: String
    var item_no: String
    var jin_title: String
    var line_price: String
    var min_order_num: Int
    var order_type: String
    var original_price: String
    var price: String
    var promotion_flag: String
    var sale_pack: String
    var spec: String
    var status: String
    var stock: Int
    var tags: [GoodsTags]
}

struct GoodsTags: Codable {
    var bgcolor: String
    var bordercolor: String
    var color: String
    var form: Int
    var ilink: String
    var name: String
    var type: Int
}
