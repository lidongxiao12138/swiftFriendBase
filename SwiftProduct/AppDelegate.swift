//
//  AppDelegate.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/13.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import UIKit
import IQKeyboardManager
import SwiftTheme


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var netObservation:Reachability?  //苹果提供的网络检测类
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //适配iOS11
        adaptationIOS_11()
        //键盘
        initIQKeyboard()
        //网络监测
        initNetworkCheck()
        //创建UI
        initUI()
        //设置导航栏、标签栏样式
        setupNavigationbarStyle()
        
        
        return true
    }
    //MARK: 构建导航栏样式
    private func setupNavigationbarStyle() {
        
        let navigationBar = UINavigationBar.appearance()
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        let titleAttributes: [[String: AnyObject]] = ["#000000"].map { hexString in
            return [
                //
                NSAttributedStringKey.foregroundColor.rawValue: UIColor(rgba: hexString),
                NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 16), //导航中间字大小
                NSAttributedStringKey.shadow.rawValue: shadow
            ]
        }
        
        navigationBar.theme_tintColor = ThemeColorPicker.pickerWithColors(["#000000"])//导航栏（左、右按钮（返回)字体)颜色
        navigationBar.theme_barTintColor = ["#FFFFFF"] //导航栏背景颜色
        navigationBar.theme_titleTextAttributes = ThemeDictionaryPicker.pickerWithDicts(titleAttributes)
        
        // tab bar
        
        let tabBar = UITabBar.appearance()
        tabBar.theme_tintColor = [UIColor().systemDefaultColor]  //字体颜色
    }
    //MARK: 构造UI
    private func initUI() {
        //状态栏的颜色 Default 表示黑色的 LightContent 白色   该方法在swift 4.0方法废弃  swift 4.0需要在viewcontroller里override 这个属性 preferredStatusBarStyle
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        self.window=UIWindow()
        self.window!.backgroundColor=UIColor.white   //设置windows是白色的 不然自定义push的时候右上角会有黑角快
        self.window!.frame=UIScreen.main.bounds
        IQKeyboardManager.shared().isEnabled = true
        
        /********************
                引导页
         ********************/
        self.window!.rootViewController = LYFTabBarController()
        self.window!.makeKeyAndVisible()
    }
    //MARK: 网络监测
    private func initNetworkCheck()->Void{
        NotificationCenter.default.addObserver(self, selector: #selector(self.monitorNetWorkStatus), name: NSNotification.Name.reachabilityChanged, object: nil)
        self.netObservation=Reachability.forInternetConnection()
        self.netObservation?.startNotifier()
        let status =  self.netObservation!.currentReachabilityStatus() as NetworkStatus
        
        switch status {
        case NotReachable:  //网络未连接
            NetWordStatus=false
            debugPrint("网络未连接")
            break
        default:
            NetWordStatus=true
            debugPrint("网络已连接")
            break
        }
    }
    
    @objc func monitorNetWorkStatus() -> Void {
        switch self.netObservation!.currentReachabilityStatus() {
        case NotReachable:  //未连接
            NetWordStatus=false
            break
        case ReachableViaWiFi:  //wifi
            NetWordStatus=true
            break
        case ReachableViaWWAN:  //移动网络 2g 3g 4g
            NetWordStatus=true
            break
        default:
            break
        }
    }
    
    //MARK: 初始化键盘管理
    private func initIQKeyboard()->Void{
        IQKeyboardManager.shared().isEnabled = true
    }
    
    //MARK: 适配iOS11
    private func adaptationIOS_11()->Void{
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            UITableView.appearance().contentInsetAdjustmentBehavior = .never
            UICollectionView.appearance().contentInsetAdjustmentBehavior = .never
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
        }
    }
    
    //MARK: window销毁
    deinit {
        netObservation?.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: appdelegate
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

