//
//  HttpManager.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/12/8.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation
import Moya
import RxSwift

//MARK: 定义http参数结构体
public struct MoyaParameter {
    var url:String
    var method:Moya.Method
    var parameter:[String: Any]
    
    init(url:String,method:Moya.Method,parameter:[String: Any]) {
        self.url=url
        self.method=method
        self.parameter=parameter
    }
}
//MARK: 拓展moya 反射参数
extension HttpApiManager {
    //反射api的参数 自动序列
    func mirrorParameter(values:HttpApiManager) -> Dictionary<String , Any> {
        var dic = Dictionary<String,Any>()
        let mirrorTran = Mirror(reflecting: values)
        for (_,value) in mirrorTran.children{
            let  Tran  = Mirror(reflecting: value)
            for (key,value) in Tran.children{
                dic[ key!]=value
            }
        }
        return dic
    }
}


//MARK: Api moya协议  此处用镜像反射不然写太多烦死
extension HttpApiManager: TargetType {
    
    
    public var baseURL: URL {
        return URL.init(string: HttpsUrl)!
    }
    
    public var path: String {  //请求API路径
        return ""
    }
    
    public var method: Moya.Method {    //get post
        return .get
    }
    
    public var task: Task {     //请求参数
        return .requestParameters(parameters: [:], encoding: URLEncoding.default)
    }
    
    public var headers: [String : String]? {  //头请求验证
        return nil
    }
    
    public var sampleData: Data {       //数据
        return "sampleData".data(using: .utf8)!
    }
    
}

//MARK: 自定义请求信息
let httpEndpoint = { (target: HttpApiManager) -> Endpoint<HttpApiManager> in
    
    let url =  target.moyaConfiguration.url
    let endpoint = Endpoint<HttpApiManager>(url: url, //请求路径
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.moyaConfiguration.method,  //get post 请求
        task:  Task.requestParameters(parameters: target.moyaConfiguration.parameter, encoding: URLEncoding.default) , //参数
        httpHeaderFields: target.headers)  //带头部请求
    return endpoint
}

//MARK: 自定义请求超时时间
let httpRequestClosure = { (endpoint: Endpoint<HttpApiManager>, done: @escaping MoyaProvider<HttpApiManager>.RequestResultClosure) in
    
    guard var request: URLRequest = try? endpoint.urlRequest() else {return}
    request.httpShouldHandleCookies = true
    request.timeoutInterval = 20    //设置请求超时时间
    done(.success(request))
}

//MARK: 网络请求指示器状态通知
let httpNetworkAcivityPlugin = NetworkActivityPlugin { (change) in
    switch(change) {
    //结束
    case .ended:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    //开始
    case .began:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
}

//MARK: JSON解析
public func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch  {
        return data //解析失败返回原数据
    }
}

//MARK: 请求管理  单例

struct HttpManager {
    
    static let share = MoyaProvider<HttpApiManager>(endpointClosure: httpEndpoint,
                                                   requestClosure: httpRequestClosure,
                                                   plugins: [NetworkLoggerPlugin(verbose: true,
                                                                                 responseDataFormatter: JSONResponseDataFormatter),
                                                             httpNetworkAcivityPlugin])
}
