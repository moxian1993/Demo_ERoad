//
//  FNProductsCollectionVM.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/16.
//

import UIKit

class FNProductsCollectionVM {
    
    var firstGradeViewModels: [FNGoodsCategoryVM]?
    
    func getViewModelWithIndexPath(_ indexPath: IndexPath) -> FNGoodsCategoryVM? {
        return firstGradeViewModels?[indexPath.row]
    }
    
    //MARK: - Request
    //分类页一级类目
    func fnrequest_getGoodsFirstGrade(completed:@escaping (Bool) -> ()) {
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
                    ["rt_no":"1055"]
                ]
            ]

        FNNetworkManager.shared.request(urlStr: FNURL_CATEGORY_GETGOODSFIRSTGRADE, method: .GET, params: params, getResponseForm: .Data) { (isSuccess, data) in

            if isSuccess {
                do {
                    let model = try JSONDecoder().decode(GoodsFirstGradeModel.self, from: data as! Data)
                    self.firstGradeViewModels = model.categories.map {
                        return FNGoodsCategoryVM(model: $0)
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



