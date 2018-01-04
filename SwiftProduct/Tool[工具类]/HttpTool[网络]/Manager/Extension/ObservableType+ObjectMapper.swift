//
//  ObservableType+ObjectMapper.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/15.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper


//MARK: 通过ObjectMapper处理对ObservableType扩展
/// 限制泛型协议的关联类型必须是  Response
public extension ObservableType where E == Response {
    
    ///将从信号接收到的数据映射到对象中
    ///实现了Mappable协议并返回结果
    ///如果转换失败，信号错误
    public func mapObject<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self, context: context))
        }
    }
    
    ///将从信号接收到的数据映射到数组中
    ///实现了Mappable协议并返回结果
    ///如果转换失败，信号错误
    public func mapArray<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self, context: context))
        }
    }
}


// MARK: - ImmutableMappable
public extension ObservableType where E == Response {
    
    ///将从信号接收到的数据映射到对象中
    ///实现了Mappable协议并返回结果
    ///如果转换失败，信号错误
    public func mapObject<T: ImmutableMappable>(_ type: T.Type, context: MapContext? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self, context: context))
        }
    }
    
    ///将从信号接收到的数据映射到数组中
    ///实现了Mappable协议并返回结果
    ///如果转换失败，信号错误
    public func mapArray<T: ImmutableMappable>(_ type: T.Type, context: MapContext? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self, context: context))
        }
    }
}
