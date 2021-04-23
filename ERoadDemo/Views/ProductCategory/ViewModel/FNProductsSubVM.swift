//
//  FNProductsSubVM.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/21.
//

import Foundation


class FNProductsSubVM {
    
    var subGradeViewModels: [FNGoodsCategoryVM]?
    var subDetailGradeViewModels: [FNGoodsCategoryVM]? 
    
    func getViewModelWithIndexPath(_ indexPath: IndexPath) -> FNGoodsCategoryVM? {
        return subGradeViewModels?[indexPath.row]
    }
    
    func getChildViewModelWithIndexPath(_ indexPath: IndexPath) -> FNGoodsCategoryVM? {
        return subDetailGradeViewModels?[indexPath.row]
    }
    
    // 获取对应cate_id
    func getCateIdForIndexPath(_ indexPath: IndexPath) -> String? {
        return getViewModelWithIndexPath(indexPath)?.model.cate_id
    }
    
    // 获取对应子cate_id
    func getChildCateIdForIndexPath(_ indexPath: IndexPath) -> String? {
        return getChildViewModelWithIndexPath(indexPath)?.model.cate_id
    }
    
    //MARK: - Request
    /// 分类页二/三级类目
    /// - Parameters:
    ///   - pid: cate_id
    ///   - isDetailSub: 是否为三级目录
    ///   - completed: completedHandle
    /// - Returns: description
    func fnrequest_getGoodsSubGrade(cate_id pid: String, isDetailSub: Bool, completed:@escaping (Bool) -> ()) {
        let params =
            ["data":
                ["head":
                    ["areaCode":"",
                     "clientId":"",
                     "apiVersion":"1.3.0",
                     "viewSize":"1284x2778",
                     "channel":"",
                     "deviceId":"AA641C59-8318-41FA-BEE7-024FA4D85E41",
                     "deviceRule":"3",
                     "osType":"2",
                     "utoken":""],
                 "body":
                    ["rt_no":"1055",
                     "pid": pid]
                ]
            ]
        
        FNNetworkManager.shared.request(urlStr: FNURL_CATEGORY_GETGOODSSUBGRADE, method: .GET, params: params, getResponseForm: .Data) { (isSuccess, data) in
            
            if isSuccess {
                do {
                    let model = try JSONDecoder().decode(GoodsSubGradeModel.self, from: data as! Data)
                    let viewModels = model.categories.map { return FNGoodsCategoryVM(model: $0) }
                    if isDetailSub {
                        self.subDetailGradeViewModels = viewModels
                    } else {
                        self.subGradeViewModels = viewModels
                    }
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
