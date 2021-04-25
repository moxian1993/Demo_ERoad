//
//  FNNetworkManager.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/16.
//

import UIKit
import Alamofire

enum FNRequestMethod {
    case GET
    case POST
}

enum FNResponseForm {
    case Data
    case JSON
}


enum ReachabilityStatus{
    case notReachable
    case unknown
    case ethernetOrWiFi
    case wwan
}


let FNURL_CATEGORY_GETGOODSFIRSTGRADE = "https://b2b-newapi.feiniu.com/category/getGoodsCatFirstGrade"
let FNURL_CATEGORY_GETGOODSSUBGRADE = "https://b2b-newapi.feiniu.com/category/getGoodsSubCatGrade"
let FNURL_SEARCH_GETCATEGORYGOODSLIST = "https://b2b-newapi.feiniu.com/search/getCategoryGoodsList"

class FNNetworkManager {

    static let shared: FNNetworkManager = {
        let instance = FNNetworkManager()
        return instance
    }()
    
    func request(urlStr: String, method:FNRequestMethod = .GET, params:[String: Any]?, getResponseForm:FNResponseForm = .Data, completed: @escaping (Bool, Any?) -> Void) {
        
        let httpMethod: HTTPMethod = method == .GET ? .get : .post
        let param = paramsFormatter(params: params)
        
        // 步骤中涉及手动 JSON转Data，所以置为在全局队列中执行
        AF.request(urlStr, method: httpMethod, parameters: param, encoder: URLEncodedFormParameterEncoder.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON(queue: DispatchQueue.global()) { (json) in
            
            guard let value = json.value else {
                DispatchQueue.main.async {
                    completed(false, nil)
                }
                return
            }

            let dic = value as! Dictionary<String, Any>
            if getResponseForm == .Data {
                let data = try! JSONSerialization.data(withJSONObject: dic["data"]!, options: .fragmentsAllowed)
                DispatchQueue.main.async {
                    completed(true, data)
                }
            } else {
                DispatchQueue.main.async {
                    completed(true, dic["data"])
                }
            }
            return
        }
    }
    
    private func paramsFormatter(params: [String: Any]?) -> [String: String]? {
        guard let paramsStr = params as? [String: String] else {
            if params == nil {
                return nil
            }
            
            var paramStr = [String: String]()
            for (key, value) in params! {
                
                let str = String(data: try! JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed), encoding: .utf8)!
                paramStr[key] = str
            }
            return paramStr
        }
        return paramsStr
    }

    
    class func netWorkReachability(reachabilityStatus: @escaping (ReachabilityStatus)->()) {
        let manager = NetworkReachabilityManager.init(host: "https://www.baidu.com")

        manager!.startListening { (status) in
             //wifi
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi){
                reachabilityStatus(.ethernetOrWiFi)
            }
            //不可用 首次请求网络权限会走这里
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable{
                reachabilityStatus(.notReachable)
            }
            //未知
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.unknown{
                reachabilityStatus(.unknown)
            }
            //蜂窝
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.cellular){
                reachabilityStatus(.wwan)
            }
        }
    }
    
}


