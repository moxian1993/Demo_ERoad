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
    
    var cate_idList: [String]?
    
    var detailInfoViewModelsList: [[FNGoodsDetailInfoVM]] = [[FNGoodsDetailInfoVM]]()

    let page_size: Int = 10
    
    var refreshParams: RefreshParams?
    
    var hasMore: Bool = true
    
    func getNumberOfSections() -> Int {
        return detailInfoViewModelsList.count
    }
    
    func getnumberOfRowsInSection(_ section: Int) -> Int {
        return detailInfoViewModelsList[section].count
    }

    func getDetailViewModelWithIndexPath(_ indexPath: IndexPath) -> FNGoodsDetailInfoVM {
        return detailInfoViewModelsList[indexPath.section][indexPath.row]
    }
    
    
    func pullNextCategoryData(completed: @escaping (_ isSuccess :Bool)->()) {
        
        guard let nextCateId = self.findNextCateId() else {
            print("--- no more")
            self.hasMore = false
            // 真实page
            self.refreshParams!.page -= 1
            completed(true)
            return
        }
        print("nextid:\(nextCateId)")
        firstPullGoodsList(isManualTurn: false, cate_id: nextCateId, completed: completed)
    }
    
    func findNextCateId() -> String? {
        
        guard let cateIDList = cate_idList,  let params = self.refreshParams  else {
            return nil
        }
        
        let index = cateIDList.firstIndex(of: params.cate_id)!
        
        if index + 1 < cateIDList.count {
            // 仍在当前二级 category中
            return cateIDList[index+1]
        } else {
            // 下一个二级 category
            return nil
        }
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
    
    
    
    /// 首次拉取数据
    /// - Parameters:
    ///   - shouldClearData: 是否清除已有数据（手动跳转需要清除，加载下一分栏不需要清除）
    ///   - cate_id: cate_id
    ///   - completed: completed
    /// - Returns: Returns
    func firstPullGoodsList(isManualTurn shouldClearData: Bool, cate_id: String, completed: @escaping (_ isSuccess: Bool)->()) {
        fnrequest_searchCategoryGoodsList(cate_id: cate_id, page: 1, page_size: page_size) { (isSuccess, obj) in
            if isSuccess {
                self.refreshParams = RefreshParams(cate_id: cate_id, page: 1)
                self.hasMore = true
                do {
                    let detailModel = try JSONDecoder().decode(GoodsDetail.self, from: obj as! Data)
                    let detailInfoViewModels = detailModel.list.map { return FNGoodsDetailInfoVM(model: $0) }
                    
                    if shouldClearData {
                        self.detailInfoViewModelsList.removeAll()
                    }
                    self.detailInfoViewModelsList.append(detailInfoViewModels)
                    print("--- firstPullCount:\(detailInfoViewModels.count)")
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
                        // 当前分栏加载完毕
                        self.pullNextCategoryData(completed: completed)
                        return
                    }
                    
                    var arr = self.detailInfoViewModelsList.last
                    arr?.append(contentsOf: viewModels)
                    
                    self.detailInfoViewModelsList.removeLast()
                    self.detailInfoViewModelsList.append(arr!)
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


