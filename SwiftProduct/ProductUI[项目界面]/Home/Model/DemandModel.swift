//
//  DemandModel.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/16.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation
import ObjectMapper

class DemandModel: Mappable {
    var content : [demandContent]?
    var result : String?
    var success : Bool?
    var ret : Int?
    required init?(map: Map){}
    func mapping(map: Map)
    {
        content <- map["Content"]
        result <- map["Result"]
        success <- map["Success"]
        ret <- map["ret"]
        
    }

}

class demandContent: Mappable {
    var cityName : String?
    var contact : String?
    var createTime : String?
    var demandID : Int?
    var describe : String?
    var images : [Image]?
    var isDel : Bool?
    var isUrgent : Bool?
    var lat : String?
    var lng : String?
    var phone : String?
    var provinceName : String?
    var releaseType : Int?
    var title : String?
    var typeNames : String?
    var userID : Int?
    required init?(map: Map){}
    func mapping(map: Map)
    {
        cityName <- map["CityName"]
        contact <- map["Contact"]
        createTime <- map["CreateTime"]
        demandID <- map["DemandID"]
        describe <- map["Describe"]
        images <- map["Images"]
        isDel <- map["IsDel"]
        isUrgent <- map["IsUrgent"]
        lat <- map["Lat"]
        lng <- map["Lng"]
        phone <- map["Phone"]
        provinceName <- map["ProvinceName"]
        releaseType <- map["ReleaseType"]
        title <- map["Title"]
        typeNames <- map["TypeNames"]
        userID <- map["UserID"]
        
    }

}

class Image: Mappable {
    
    var createTime : String?
    var imgDescribe : String?
    var imgID : Int?
    var imgPath : String?
    var imgType : Int?
    var otherID : Int?
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        createTime <- map["CreateTime"]
        imgDescribe <- map["ImgDescribe"]
        imgID <- map["ImgID"]
        imgPath <- map["ImgPath"]
        imgType <- map["ImgType"]
        otherID <- map["OtherID"]
        
    }

}
