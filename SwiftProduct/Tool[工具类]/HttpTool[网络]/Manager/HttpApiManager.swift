//
//  HttpApiManager.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/12/8.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation
import Moya

/// 接口名称
public enum HttpApiManager {
    
    case getCityList    //获取城市数据
    case getDemandInfoList( PageIndex:Int ,PageSize:Int ,CityName:String)
    case getText
}

extension HttpApiManager {
    public var moyaConfiguration:MoyaParameter {
        switch self {
        case .getCityList:
            return MoyaParameter(url: HttpsUrl+"api/City/GetCityList",
                                        method:Moya.Method.get,
                                        parameter:mirrorParameter(values: self))
            
        case .getDemandInfoList :
            return MoyaParameter(url: HttpsUrl+"api/System/GetDemandInfoList",
                                        method: Moya.Method.get,
                                        parameter: mirrorParameter(values: self))
        case .getText:
            return MoyaParameter(url: "http://gxyp.shop/index.php/Index/index",
                                 method: Moya.Method.post,
                                 parameter: mirrorParameter(values: self))
        }
    }
}
