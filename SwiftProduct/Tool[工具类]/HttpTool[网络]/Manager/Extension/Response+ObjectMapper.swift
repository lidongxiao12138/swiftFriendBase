//
//  Response+ObjectMapper.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/15.
//  Copyright © 2017年 梁元峰. All rights reserved.
//


import Foundation
import Moya
import ObjectMapper

//MARK: Mappable
public extension Response {
    ///将从信号接收的数据映射到实现可映射协议的对象中
    ///如果转换失败，信号错误
    public func mapObject<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) throws -> T {
        guard let object = Mapper<T>(context: context).map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        /********************  这里还可以补充  ********************/
        /********************
                 guard let object = Mapper<ReusltModel>(context: context).map(JSONObject: try mapJSON()) else {
                 throw MoyaError.jsonMapping(self)
                 }
                 let model = object.data as! T
         ********************/
        return object
    }
    
    ///将从信号接收到的数据映射到实现可映射的对象数组中
    ///如果转换失败，信号错误
    public func mapArray<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) throws -> [T] {
        guard let array = try mapJSON() as? [[String : Any]] else {
            throw MoyaError.jsonMapping(self)
        }
        return Mapper<T>(context: context).mapArray(JSONArray: array)
    }
    
    
}

// MARK: ImmutableMappable
public extension Response {
    
    public func mapObject<T: ImmutableMappable>(_ type: T.Type, context: MapContext? = nil) throws -> T {
        return try Mapper<T>(context: context).map(JSONObject: try mapJSON())
    }

    public func mapArray<T: ImmutableMappable>(_ type: T.Type, context: MapContext? = nil) throws -> [T] {
        guard let array = try mapJSON() as? [[String : Any]] else {
            throw MoyaError.jsonMapping(self)
        }
        return try Mapper<T>(context: context).mapArray(JSONArray: array)
    }
}
