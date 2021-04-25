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
                    FNToastManager.hide()
                    
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    
    var cate_name: String? {
        didSet {
            headViewLab?.text = cate_name
        }
    }
    
    var headViewLab: UILabel?
    
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.tableHeaderView = headView
        tableView.tableHeaderView?.frame.size.height = 50
        tableView.sectionFooterHeight = 0
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var headView: UIView = {
        let v = UIView()
        
        let lab = UILabel()
        lab.textColor = lightGrayTextColor
        lab.font = UIFont.systemFont(ofSize: 15)
        v.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        self.headViewLab = lab
        
        let line = UIView()
        line.backgroundColor = categoryColor
        v.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(lab.snp.right).offset(15)
            // 在此设置 right 会有约束冲突，暂时设置定宽
            make.width.equalTo(1000)
            make.height.equalTo(1)
        }
        return v
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
