//
//  NetworkActivityPlugin.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/14.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation
import Moya
import Result

//MARK: 请求状态
public enum NetworkActivityChangeType { case began, ended  }

//MARK: moya插件
///该类不能被外部修改、不能被继承
public final class NetworkActivityPlugin: PluginType {
    
    public typealias NetworkActivityClosure = (_ change: NetworkActivityChangeType) -> Void
    let networkActivityClosure: NetworkActivityClosure
    
    /// init
    ///
    /// - Parameter networkActivityClosure: 网络状态闭包
    public init(networkActivityClosure: @escaping NetworkActivityClosure) {
        self.networkActivityClosure = networkActivityClosure
    }
    
    //MARK: Plugin
    /// 即将开始发送请求
    public func willSend(_ request: RequestType, target: TargetType) {
        self.networkActivityClosure(.began)
    }
    /// 在收到响应之后，但在MoyaProvider调用其完成处理程序之前调用。
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        self.networkActivityClosure(.ended)
    }
}
