//
//  TextModel.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/17.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import UIKit
import ObjectMapper

class TextModel: Mappable {
    var data : DataModel?
    var msg : String?
    var status : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        data <- map["data"]
        msg <- map["msg"]
        status <- map["status"]
        
    }
}

class DataModel: Mappable {
    var indexGoods : [IndexGood]?
    var indexType : [IndexType]?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        indexGoods <- map["index_goods"]
        indexType <- map["index_type"]
        
    }

}

class IndexGood: Mappable {
    
    var cashtype : String?
    var content : String?
    var credit : String?
    var goodsid : String?
    var goodspic : String?
    var goodstype : String?
    var infopic : String?
    var inventory : String?
    var oldPrice : String?
    var price : String?
    var soldOut : String?
    var title : String?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        cashtype <- map["cashtype"]
        content <- map["content"]
        credit <- map["credit"]
        goodsid <- map["goodsid"]
        goodspic <- map["goodspic"]
        goodstype <- map["goodstype"]
        infopic <- map["infopic"]
        inventory <- map["inventory"]
        oldPrice <- map["old_price"]
        price <- map["price"]
        soldOut <- map["sold_out"]
        title <- map["title"]
        
    }


}

class IndexType: Mappable {
    var typeid : String?
    var typename : String?
    var typepic : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        typeid <- map["typeid"]
        typename <- map["typename"]
        typepic <- map["typepic"]
        
    }
}



