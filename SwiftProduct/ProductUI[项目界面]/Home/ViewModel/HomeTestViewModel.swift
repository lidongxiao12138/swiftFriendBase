//
//  HomeTestViewModel.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/12/22.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeTestViewModel: BaseViewModel {
    
    var modelObserable = Variable<[demandContent]>([]) //数据数组
    var pageIndex = 1
    var pageSize = 10
    
    override func setConfig(tableView: UITableView!) {
        
        //设置tablev
        super.setConfig(tableView: tableView)
        
        
        //请求数据
        self.publishHttpRequest(isHeaderShow: true, isFooterShow: true) { (statu) in
            if statu == .header {
                self.pageIndex = 1
            }
            else if statu == .footer {
                self.pageIndex += 1
            }
        self.getData(moyaParmter: .getDemandInfoList( PageIndex:self.pageIndex ,PageSize:self.pageSize ,CityName:"南宁市"), model: DemandModel.self, onNext: { (data) in
            guard let dataArray = data.content else { //第一次加载没有数据
                return
            }
            
            if self.pageIndex == 1 {
                self.modelObserable.value = dataArray
                self.tableViewStatuObserable.value = .endHeaderRefresh
            }else{
                self.modelObserable.value += dataArray
                self.tableViewStatuObserable.value = .endFooterRefresh
            }
            if(dataArray.count<self.pageSize){
                self.tableViewStatuObserable.value = .noMoreData    //没有更多数据
            }
            }, onError: { (error) in
                debugPrint(error)
                self.tableViewStatuObserable.value = .endHeaderRefresh
                self.tableViewStatuObserable.value = .endFooterRefresh
            }, onCompleted: {
                
            })
        }
        
        
        //绑定数据
        modelObserable.asObservable()
            .bind(to: (tableView?.rx.items(cellIdentifier: "HomeDemanCell", cellType: HomeDemanCell.self))!) { row, model, cell in
                
                cell.demanTitlLabel.text = model.title
                cell.demanContentLabel.text = model.describe
                cell.demanDateLabel.text = model.createTime
                
                if (model.images?.count)! > 0 {
                    cell.demanImageView.isHidden = false
                    cell.demanImageView.setImage(url: HttpsUrlImage+model.images![0].imgPath!)
                    cell.leadingConstraint.constant = 120
                }else{
                    cell.demanImageView.isHidden = true
                    cell.leadingConstraint.constant = 15
                }
                
            }
            .disposed(by: dispose)
    }
    
    override func placeholderButton_Click() {
        debugPrint("I am click this button")
    }
}
