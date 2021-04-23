//
//  FNProductDetailVM.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/22.
//

import Foundation

class FNProductsDetailVM {
    
    private var detailModel: GoodsDetail?
    var detailInfoViewModels: [FNGoodsDetailInfoVM]?
    
    var sortInfo: [SortInfo]? {
        return detailModel?.sortInfo
    }
    var Goods: [Goods]? {
        return detailModel?.list
    }
    var total: Int {
        return detailModel?.total ?? 0
    }
    
    func getDetailViewModelWithIndexPath(_ indexPath: IndexPath) -> FNGoodsDetailInfoVM? {
        return detailInfoViewModels?[indexPath.row]
    }
    
    //MARK: - Request
    //分类页对应类目的商品列表数据
    func fnrequest_searchCategoryGoodsList(cate_id: String, page: Int, page_size: Int = 10, completed:@escaping (Bool) -> ()) {
        let params =
            [
                "data":
                    [
                        "head":
                            ["deviceId":"AA641C59-8318-41FA-BEE7-024FA4D85E41"],
                        "body":
                            ["cateid": cate_id,
                             "rt_no":"1055",
                             "page":page,
                             "page_size": page_size,
                             "order_flag":"0",
                             "sale_order_flag":"4",
                             "query_bottom":"0",
                             "brand_id":""]
                    ]
            ]
        
        FNNetworkManager.shared.request(urlStr: FNURL_SEARCH_GETCATEGORYGOODSLIST, method: .POST, params: params) { (isSuccess, obj) in
            if isSuccess {
                do {
                    self.detailModel = try JSONDecoder().decode(GoodsDetail.self, from: obj as! Data)
                    self.detailInfoViewModels = self.detailModel?.list.map { return FNGoodsDetailInfoVM(model: $0) }
                    completed(true)
                } catch let error {
                    print(error)
                    completed(false)
                }
            } else {
                completed(false)
            }
        }
    }

    
    
}


