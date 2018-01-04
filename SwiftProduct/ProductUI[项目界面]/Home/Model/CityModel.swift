//
//  CityModel.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/16.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation
import ObjectMapper



class CityModel:  Mappable{
    
    var content : [Content]?
    var result : String?
    var success : Bool?
    var ret : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        content <- map["Content"]
        result <- map["Result"]
        success <- map["Success"]
        ret <- map["ret"]
        
    }
}

class Content: Mappable {
    required init?(map: Map) {
        
    }
    
    
    var cityName : String?
    var iD : Int?
    var parentID : Int?
    var provinceName : String?
    var isShow : Bool?
    
    func mapping(map: Map)
    {
        cityName <- map["CityName"]
        iD <- map["ID"]
        parentID <- map["ParentID"]
        provinceName <- map["ProvinceName"]
        isShow <- map["isShow"]
        
    }
}


