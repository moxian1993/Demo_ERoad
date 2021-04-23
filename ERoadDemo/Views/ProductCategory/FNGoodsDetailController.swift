//
//  FNGoodsDetailController.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/22.
//

import UIKit
import MJRefresh

class FNGoodsDetailController: FNBaseViewController {
    
    var detailVM: FNProductsDetailVM?
    
    var cate_id: String? {
        didSet{
            detailVM?.fnrequest_searchCategoryGoodsList(cate_id: cate_id ?? "140085272", page: 1, page_size: 100) { (isSuccess) in
                if isSuccess {
                    self.tableView.reloadData()
//                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        detailVM = FNProductsDetailVM()
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FNGoodsDetailCell.self, forCellReuseIdentifier: NSStringFromClass(FNGoodsDetailCell.self))
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
//        tableView.tableHeaderView = UIView()
//        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 0
        tableView.separatorStyle = .none
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        return tableView
    }()

}

extension FNGoodsDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailVM?.Goods?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FNGoodsDetailCell.self), for: indexPath) as! FNGoodsDetailCell
        if let viewModel = detailVM?.getDetailViewModelWithIndexPath(indexPath) {
            cell.viewModel = viewModel
        }
        return cell
    }
    
}
