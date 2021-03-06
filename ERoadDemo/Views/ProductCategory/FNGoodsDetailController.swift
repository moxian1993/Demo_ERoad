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
    
    var cate_idList: [String]? {
        set {
            self.detailVM?.cate_idList = newValue
        }
        get {
            return self.detailVM?.cate_idList
        }
    }
    
    var cate_nameList: [String]? {
        set {
            self.detailVM?.cate_nameList = newValue
        }
        get {
            return self.detailVM?.cate_nameList
        }
    }
    
    var cate_id: String? {
        didSet{
            detailVM?.cate_id_initial = cate_id
            detailVM?.firstPullGoodsList(isManualTurn: true, cate_id: cate_id ?? "140085272") { (isSuccess) in
                if isSuccess {
                    FNToastManager.hide()
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    self.tableView.resetNoMoreData()
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
        tableView.refreshDelegate = self
        tableView.register(FNGoodsDetailCell.self, forCellReuseIdentifier: NSStringFromClass(FNGoodsDetailCell.self))
    }
    
    func createHeaderViewForSection(_ section: Int) -> UIView {
        let v = UIView()
        
        let lab = UILabel()
        lab.textColor = lightGrayTextColor
        lab.font = UIFont.systemFont(ofSize: 15)
        v.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        lab.text = detailVM?.getTextForHeaderViewInSection(section)
        
        let line = UIView()
        line.backgroundColor = categoryColor
        v.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(lab.snp.right).offset(15)
            // ???????????? right ???????????????????????????????????????
            make.width.equalTo(1000)
            make.height.equalTo(1)
        }
        return v
    }

    private lazy var tableView: MKRefreshTableView = {
        let tableView = MKRefreshTableView(frame: CGRect(), style: .grouped)
        tableView.setHeaderOnlyActivityControlWithUseArrorIcon(true)
        tableView.hideHeader()
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        return tableView
    }()
    
}

extension FNGoodsDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailVM?.getNumberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailVM?.getnumberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FNGoodsDetailCell.self), for: indexPath) as! FNGoodsDetailCell
        if let viewModel = detailVM?.getDetailViewModelWithIndexPath(indexPath) {
            cell.viewModel = viewModel
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderViewForSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension FNGoodsDetailController: MKRefreshTableViewDelegate {
    
    func tableView(_ tableView: MKRefreshTableView!, footerRefreshEnding refreshEnding: (() -> Void)!) {
        detailVM?.nextPage { (isSuccess) in
            if isSuccess {
                self.tableView.reloadData()
            }
            let hasMore = self.detailVM?.hasMore ?? false
            print(hasMore)
            tableView.hasMore(hasMore)
            refreshEnding()
        }
    }
}
