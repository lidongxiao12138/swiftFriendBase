//
//  Device.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/21.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation

public final class Device {
    
    //MARK: 单例
    //单例
    
    static var  instance : Device {
        struct shared {
            static let instance : Device = Device()
        }
        return shared.instance
    }
    
    // MARK:导航栏高度和屏幕宽高度
    
    /// 状态栏高度
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    /// 导航栏的高度
    static let navigationControllerHeight = UIApplication.shared.statusBarFrame.height+44
    /// 屏幕的宽度
    static let kScreenWidth = UIScreen.main.bounds.size.width
    /// 屏幕的高度
    static let kScreenHeight = UIScreen.main.bounds.size.height
    /// 根视图
    static let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
    ///ios 版本
    static  let deviceVersion : NSString = UIDevice.current.systemVersion as NSString
    ///设备 udid
    static  let deviceUUID = UIDevice.current.identifierForVendor
    /// 设备名称
    static  let deviceName = UIDevice.current.systemName
    /// 设备型号
    static let  deviceModel = UIDevice.current.model
    /// 设备区域化型号 如 A1533
    static let deviceLocalizedModel = UIDevice.current.localizedModel
    
    
}


