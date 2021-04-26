//
//  FNProductDetailVM.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/22.
//

import Foundation

struct RefreshParams {
    var cate_id: String = ""
    var page: Int = 1
}

class FNProductsDetailVM {
    
    private var detailModel: GoodsDetail?
    var detailInfoViewModels: [FNGoodsDetailInfoVM]?
    
    var sortInfo: [SortInfo]? {
        return detailModel?.sortInfo
    }
    var Goods: [Goods]? {
        return detailModel?.list
    }
    
    // 不准确 不要用
    var total: Int {
        return detailModel?.total ?? 0
    }

    let page_size: Int = 10
    
    var refreshParams: RefreshParams?
    
    var hasMore: Bool = true

    func getDetailViewModelWithIndexPath(_ indexPath: IndexPath) -> FNGoodsDetailInfoVM? {
        return detailInfoViewModels?[indexPath.row]
    }
    
    //MARK: - Request
    //分类页对应类目的商品列表数据
    func fnrequest_searchCategoryGoodsList(cate_id: String, page: Int, page_size: Int = 10, completed:@escaping (Bool, Any?) -> ()) {
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
                completed(true, obj)
            } else {
                completed(false, "network error")
            }
        }
    }
    
    
    
    //MARK: - 第一次拉取
    func firstPullGoodsList(cate_id: String, completed: @escaping (_ isSuccess: Bool)->()) {
        fnrequest_searchCategoryGoodsList(cate_id: cate_id, page: 1, page_size: page_size) { (isSuccess, obj) in
            if isSuccess {
                self.refreshParams = RefreshParams(cate_id: cate_id, page: 1)
                self.hasMore = true
                do {
                    self.detailModel = try JSONDecoder().decode(GoodsDetail.self, from: obj as! Data)
                    self.detailInfoViewModels = self.detailModel?.list.map { return FNGoodsDetailInfoVM(model: $0) }
                    
                    print("--- firstPull total:\(self.detailModel?.total ?? 0), vms:\(self.detailInfoViewModels?.count ?? 0)")
                    completed(true)
                } catch _ {
                    completed(false)
                }
            } else {
                completed(false)
            }
        }
    }
    
    
    
    func nextPage(completed: @escaping (_ isSuccess: Bool)->()) {
        if self.refreshParams == nil {
            return
        }
        // page ++
        self.refreshParams!.page += 1
        
        let cate_id = self.refreshParams!.cate_id
        let page = self.refreshParams!.page
        
        fnrequest_searchCategoryGoodsList(cate_id: cate_id, page: page) { (isSuccess, obj) in
            if isSuccess {
                do {
                    let goodsDetails = try JSONDecoder().decode(GoodsDetail.self, from: obj as! Data)
                    let viewModels = goodsDetails.list.map { return FNGoodsDetailInfoVM(model: $0) }
                    
                    if viewModels.count == 0 {
                        print("--- no more")
                        self.hasMore = false
                        // 真实page
                        self.refreshParams!.page -= 1
                        completed(true)
                        return
                    }
                    
                    self.detailModel?.list.append(contentsOf: goodsDetails.list)
                    self.detailInfoViewModels?.append(contentsOf: viewModels)
                    
                    print("--- cate_id:\(cate_id), page:\(page), total:\(self.detailModel?.total ?? 0),\nnew:\(goodsDetails.list.count), now:\(self.detailInfoViewModels?.count ?? 0)")
                    completed(true)
                } catch {
                    completed(false)
                }
            } else {
                completed(false)
            }
        }
    }

    
    
}


