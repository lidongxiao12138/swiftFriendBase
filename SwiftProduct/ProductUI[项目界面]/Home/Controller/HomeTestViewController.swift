//
//  HomeTestViewController.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/12/25.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya

class HomeTestViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var bag : DisposeBag = DisposeBag()
    private var viewModel = HomeTestViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "test"
        
        tableView.rowHeight = 120
        tableView.tableFooterView = UIView()
        viewModel.setConfig(tableView: tableView)
        
        tableView.rx
            .modelSelected(demandContent.self)
            .subscribe(
                onNext:{
                    model in
                    debugPrint(model.title ?? "")
            })
            .disposed(by: bag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

