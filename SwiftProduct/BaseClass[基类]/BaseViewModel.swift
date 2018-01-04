//
//  BaseViewModel.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/29.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import MJRefresh
import ObjectMapper
import DZNEmptyDataSet


///定义table刷新状态
public enum TableRefreshStatu {
    case none
    case beginHeaderRefresh
    case endHeaderRefresh
    case beginFooterRefresh
    case endFooterRefresh
    case noMoreData
    case netError
}
///
public enum SlippageStatu {
    case header 
    case footer
}
///请求状态
public enum NewWorkStatu {
    case none
    case loading
    case normal
    case noNet
    case filed
}

///
class BaseViewModel: NSObject {
    
    var tableViewStatuObserable = Variable<TableRefreshStatu>(.none) //状态
    var networkStatusObserble = Variable<NewWorkStatu>(.none)
    var dispose: DisposeBag = DisposeBag() //消息包
    var tableView: UITableView!
    /// tableView
    private var isHeaderShow:Bool!
    private var isFooterShow:Bool!
    /// DZNEmptyDataSetSource
    private var placeholderTitle = ""//标题
    private var placeholderDescription = ""//描述
    private var placeholderButtonTitle = ""//按钮名
    private var placeholderImage = ""//占位logo
    private var placeholderLoadingImage = ""//加载图
    ///
    private var isLoading = true
    
    /// 空视图
    /// 加载时(不需要描述和按钮名)
    var loadingTitle = ""///加载占位标题文字
    var loadingImage = "loading"   ///加载占位动图git格式
    /// 没有数据
    var nodataTitle = "没有数据"
    var nodataDescription = "我找不到数据了 T T"
    var nodataImage = "nodata"
    /// 没有网络
    var nonetTitle = "网络异常"
    var nonetDescription = "我好像连接不上网络了...请检查一下网络"
    var nonetImage = "nonet"
    var nonetButtonTitle = "重新加载"
    /// 请求失败
    var failedTitle = "请求失败"
    var failedDescription = "请重新加载数据"
    var failedImage = "ServerRequestFailed"
    var failedButtonTitle = "重新加载"
    
    
    //MARK: 配置tableview
    func setConfig(tableView:UITableView!) -> Void {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        //tableview操作
        tableViewStatuObserable.asObservable()
            .subscribe(onNext: { (statu) in
                
                switch statu {
                case .beginHeaderRefresh:
                    tableView.mj_header.beginRefreshing()
                case .endHeaderRefresh:
                    tableView.mj_header.endRefreshing()
                case .beginFooterRefresh:
                    tableView.mj_footer.beginRefreshing()
                case .endFooterRefresh:
                    tableView.mj_footer.endRefreshing()
                case .noMoreData:
                    tableView.mj_footer.endRefreshingWithNoMoreData()
                default: break
                }
                
            }).disposed(by: dispose)
        self.tableView = tableView
        
        //DZNEmptyDataSetSource操作
        networkStatusObserble.asObservable().subscribe(onNext: { (statu) in
            switch statu {
            case .normal:
                self.placeholderTitle = self.nodataTitle
                self.placeholderDescription = self.nodataDescription
                self.placeholderImage = self.nodataImage
            case .loading:
                self.placeholderTitle = self.loadingTitle
                self.placeholderLoadingImage = self.loadingImage
            case .noNet:
                self.placeholderTitle = self.nonetTitle
                self.placeholderDescription = self.nonetDescription
                self.placeholderImage = self.nonetImage
                self.placeholderButtonTitle = self.nonetButtonTitle
            case .filed:
                self.placeholderTitle = self.failedTitle
                self.placeholderDescription = self.failedDescription
                self.placeholderImage = self.failedImage
                self.placeholderButtonTitle = self.failedButtonTitle
            default:

                break
            }
            //回到主队列
            DispatchQueue.main.async {
                self.tableView.reloadEmptyDataSet()
            }
        }).disposed(by: dispose)
    }
    
    //MARK: 订阅事件   适用于无头部尾部
    func publishRequest<T:PublishSubject<Any>>(type:T , closure:@escaping ((_ element:Any?) -> Void)){
        type.subscribe({ (event) in
            closure(event.element )
        }).disposed(by: self.dispose)
    }
    
    //MARK: 发送数据请求
    
    /// 订阅Http请求数据
    ///
    /// - Parameters:
    ///   - isHeaderShow: 是否显示头部
    ///   - isFooterShow: 是否显示尾部
    ///   - closure: 状态回调
    func publishHttpRequest(isHeaderShow:Bool,
                            isFooterShow:Bool,
                            closure:@escaping ((_ element:SlippageStatu?) -> Void))  {
        
        self.isHeaderShow = isHeaderShow
        self.isFooterShow = isFooterShow
        //订阅刷新事件
        let getDataCommond = PublishSubject<SlippageStatu>()
        
        if isHeaderShow {
            self.tableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                getDataCommond.onNext(.header)  //向下滑动  顶部刷新
            })
        }
        if isFooterShow {
            self.tableView?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                getDataCommond.onNext(.footer) //向上滑动  尾部刷新
            })
        }
        //收到消息
        getDataCommond.subscribe { (event) in
            //回调
            closure(event.element)
            
            }.disposed(by: dispose)
        // 刷新占位图
        self.networkStatusObserble.value = .loading
        
        //默认头部刷新
        getDataCommond.onNext(.header)
        
       
    }
    //MARK: 获取数据
    
    
    /// 发起请求
    ///
    /// - Parameters:
    ///   - moyaParmter: moya反射的配置参数
    ///   - model: 当前model
    ///   - onNext: 成功闭包
    ///   - onError: 失败闭包
    ///   - onCompleted: 完成闭包
    func getData<T:BaseMappable>(moyaParmter:HttpApiManager,
                                 model:T.Type ,onNext:@escaping ((_ dataModel:T) -> Void),
                                 onError:@escaping ((_ dataError:Any) -> Void),
                                 onCompleted: @escaping (() -> Void)) {
        
        HttpManager.share.rx.request(moyaParmter)
            .asObservable()
            .filterSuccessfulStatusAndRedirectCodes()
            .mapObject(model)
            .subscribe(onNext: { (mapmodel) in
                onNext(mapmodel)
                self.isLoading = false
                //cell为0 且有尾部视图时footer的操作
                if( self.tableView.visibleCells.count==0){
                    if self.isFooterShow {
                        self.tableView.mj_footer.isHidden=true
                    }
                }else{
                    if self.isFooterShow {
                        self.tableView.mj_footer.isHidden=false
                    }
                }
                self.networkStatusObserble.value = .normal
            }, onError: { (error) in
                self.isLoading = false
                if self.isFooterShow {
                    self.tableView.mj_footer.isHidden=true
                }
                onError(error) 
                
                if NetWordStatus {
                    self.networkStatusObserble.value = .filed
                }else{
                    self.networkStatusObserble.value = .noNet
                }
            }, onCompleted: {
                onCompleted()
                self.isLoading = false
                self.networkStatusObserble.value = .none
            }).disposed(by: self.dispose)
    }
    //MARK: 按钮点击事件
    func placeholderButton_Click()  {
        
    }
}

extension BaseViewModel:DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    //-------------------------emptyDataSet-------------------------

    /**
     *  返回标题文字
     */
    internal func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let paragraph=NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center

        let dic = [NSAttributedStringKey.font:UIFont.systemFont(ofSize:14),
                   NSAttributedStringKey.foregroundColor:UIColor.RGB(145, g: 148, b: 153),
                   NSAttributedStringKey.paragraphStyle:paragraph]

        let attributes = NSMutableAttributedString(string: placeholderTitle, attributes: dic)

        return attributes
    }

    /**
     *  标题明细文字
     */
    internal func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {

        let paragraph=NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center

        let dic = [NSAttributedStringKey.font:UIFont.systemFont(ofSize:12),
                   NSAttributedStringKey.foregroundColor:UIColor.RGB(145, g: 148, b: 153),
                   NSAttributedStringKey.paragraphStyle:paragraph]

        let attributes = NSMutableAttributedString(string: placeholderDescription, attributes: dic)

        return attributes
    }
    /**
     *  按钮图标标题
     */
    internal func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {

        let dic = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),
                   NSAttributedStringKey.foregroundColor:UIColor.white]

        let attributes = NSMutableAttributedString(string:placeholderButtonTitle, attributes: dic)

        return attributes
    }
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        var imgname="button_background_kickstarter_normal"
        if(state == .normal){
            imgname="button_background_kickstarter_normal"
        }
        if(state == .highlighted){
            imgname="button_background_kickstarter_highlight"
        }

        var capInsets:UIEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        var rectInsets:UIEdgeInsets  = UIEdgeInsets.zero

        capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
        rectInsets = UIEdgeInsetsMake(0.0, -20, 0.0, -20);

        let uiimage=UIImage(named: imgname)
        uiimage?.resizableImage(withCapInsets: capInsets, resizingMode: .stretch).withAlignmentRectInsets(rectInsets)

        return  uiimage
    }
    /**
     *  返回图标LOGO
     */
    internal func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {

        if(isLoading==false){
            return UIImage(named: placeholderImage)
        }
        return UIImage.gif(name: loadingImage)
    }
    /**
     *  返回垂直偏移量
     */
    internal func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {

        return 0.0
    }
    /**
     *  返回背景颜色
     */
    internal func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }

    /**
     *  返回高度的间隙(空间)
     */
    internal func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 15.0
    }

    /**
     *  数据源为空时是否渲染和显示
     */
    internal  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }

    /**
     *  是否允许点击
     */
    internal  func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    /**
     *  是否允许滚动
     */
    internal func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    /**
     *  空白处区域点击事件
     */
    internal func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {

        debugPrint("别点我,我是空白view点我干嘛？,我是在Deubg状态下才出来的哟")

    }
    /**
     *  按钮点击事件
     */
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        debugPrint("点击到了按钮!,我是在Deubg状态下才出来的哟")
        placeholderButton_Click()

    }
}

