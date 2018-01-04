//
//  LYFTabBarController.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/21.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation
import CYLTabBarController
import UIKit

extension UINavigationBar {
    
    ///隐藏线条底部线条
    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(view: self)
        navigationBarImageView!.isHidden = true
    }
    
    ///显示线条底部线条
    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(view: self)
        navigationBarImageView!.isHidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.classForCoder()) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInNavigationBar(view: subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}

class  LYFNavigationController:UINavigationController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //导航栏颜色渐变---需要的时候开启 不需要不用开启
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            //如果当前的viewcontroller.count大于0 表示不再这个页面内 则 隐藏掉TabbarController
            viewController.hidesBottomBarWhenPushed = true
            
        }
        
        //修改导航栏的返回样式  title为 “” 表示只有箭头了
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        viewController.navigationItem.backBarButtonItem = item;
        
        super.pushViewController(viewController, animated: animated)
    }
    
}


public final class LYFTabBarController: CYLTabBarController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        var tabBarItemsAttributes = Array<Any>()
        var viewControllers = Array<Any>()
        
        for i in 0 ... TabBar_Title.count - 1 {
            let dict: [AnyHashable: Any] = [
                CYLTabBarItemTitle: TabBar_Title[i],   //标题
                CYLTabBarItemImage: TabBar_NoSelectedImage[i], //未选择图片
                CYLTabBarItemSelectedImage: TabBar_SelectedImage[i]    //选择图片
            ]
            let vc = UIStoryboard(name: TabBar_StoryName[i], bundle: nil).instantiateViewController(withIdentifier: TabBar_StoryName[i])
            
            let rootNavigationController = LYFNavigationController(rootViewController: vc)   //添加自定义导航控制器   如果是append  vc 则不会出现navigationcontrooler
            //rootNavigationController.navigationBar.hideBottomHairline()//隐藏线条
            
            vc.title=TabBar_Title[i]   //标题
            
            tabBarItemsAttributes.append(dict as AnyObject)
            
            viewControllers.append(rootNavigationController)
        }
        self.tabBarItemsAttributes = tabBarItemsAttributes as! [[AnyHashable: Any]]
        
        self.viewControllers = viewControllers as! [ UIViewController]
        
    }
}

