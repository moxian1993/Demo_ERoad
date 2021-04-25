//
//  FNGoodsSubController.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/21.
//

import UIKit

class FNGoodsSubController: FNBaseViewController {
    
    var subVM: FNProductsSubVM?
    var cate_id: String? {
        didSet {
            guard let vm = subVM else { return }
            vm.fnrequest_getGoodsSubGrade(cate_id: cate_id ?? "140083371", isDetailSub: false) { (isSuccess) in
                if isSuccess {
                    self.leftTableView.reloadData()
                    DispatchQueue.main.async {
                        self.leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
                        
                        self.selectedIndex = nil
                        self.tableView(self.leftTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                        
                        self.grayLine.isHidden = false
                        self.btnsView.isHidden = false
                    }
                }
            }
        }
    }
    
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = _Color("white")
        subVM = FNProductsSubVM()
        setupLeftTableView()
        setupRightTopView()
        setupBtns()
        setupDetailVC()
    }
    
    private func setupLeftTableView() {
        view.addSubview(leftTableView)
        leftTableView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        
        leftTableView.dataSource = self
        leftTableView.delegate = self
        
        leftTableView.register(FNGoodsSubCell.self, forCellReuseIdentifier: NSStringFromClass(FNGoodsSubCell.self))
    }
    
    private func setupRightTopView() {
        view.addSubview(rightTopView)
        rightTopView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalTo(leftTableView.snp.right)
            make.height.equalTo(40)
        }
        
        rightTopView.dataSource = self
        rightTopView.delegate = self
        rightTopView.register(FNGoodsSubRightCell.self, forCellWithReuseIdentifier: NSStringFromClass(FNGoodsSubRightCell.self))
    }
    
    private func setupBtns() {
        view.addSubview(grayLine)
        grayLine.snp.makeConstraints { (make) in
            make.top.equalTo(rightTopView.snp.bottom).offset(0)
            make.left.right.equalTo(rightTopView)
            make.height.equalTo(1)
        }
        grayLine.isHidden = true
        
        view.addSubview(btnsView)
        btnsView.snp.makeConstraints { (make) in
            make.top.equalTo(grayLine.snp.bottom).offset(5)
            make.left.equalTo(grayLine).offset(5)
            make.right.equalTo(grayLine).offset(-5)
            make.height.equalTo(30)
        }
        btnsView.isHidden = true

        btnsView.volumeBtnDidClickedClosure = { (btn) in
            print(btn)
        }
        
        btnsView.sortedBtnDidClickedClosure = { (btn) in
            print(btn)
        }
        
        btnsView.brandBtnDidClickedClosure = { (btn) in
            print(btn)
        }
    }
    
    private func setupDetailVC() {
        addChild(detailController)
        view.addSubview(detailController.view)
        detailController.didMove(toParent: self)
        
        detailController.view.snp.makeConstraints { (make) in
            make.top.equalTo(btnsView.snp.bottom)
            make.left.equalTo(leftTableView.snp.right)
            make.bottom.right.equalToSuperview()
        }
    }
    
    
    private lazy var leftTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.backgroundColor = categoryColor
        tableView.rowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: -39, right: 0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    private lazy var rightTopView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.minimumLineSpacing = 0
        let v = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        v.backgroundColor = UIColor.white
        v.alwaysBounceHorizontal = true
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return v
    }()
    
    private lazy var grayLine: UIView = {
        let v = UIView(frame: CGRect())
        v.backgroundColor = categoryColor
        return v
    }()
    
    private lazy var btnsView: FNSortBtnsView = {
        let v = FNSortBtnsView()
        v.backgroundColor = categoryColor
        return v
    }()
    
    private lazy var detailController: FNGoodsDetailController = {
        let vc = FNGoodsDetailController()
        return vc
    }()
    
}


extension FNGoodsSubController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subVM?.subGradeViewModels?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FNGoodsSubCell.self), for: indexPath)
        if let viewModel = subVM?.subGradeViewModels?[indexPath.row] {
            cell.textLabel?.text = viewModel.model.cate_name
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath {
            return
        }
        selectedIndex = indexPath
        FNToastManager.show()
        
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        let cate_id = subVM?.getCateIdForIndexPath(indexPath) ?? "140085272"
        subVM?.fnrequest_getGoodsSubGrade(cate_id: cate_id, isDetailSub: true) { (isSuccess) in
            if isSuccess {
                self.rightTopView.reloadData()
                let initialIndexPath = IndexPath(item: 0, section: 0)
                self.rightTopView.selectItem(at: initialIndexPath, animated: false, scrollPosition: .left)
                self.collectionView(self.rightTopView, didSelectItemAt: initialIndexPath)
            }
        }
    }
}

extension FNGoodsSubController: UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subVM?.subDetailGradeViewModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FNGoodsSubRightCell.self), for: indexPath) as! FNGoodsSubRightCell
        
        if let viewModel = subVM?.getChildViewModelWithIndexPath(indexPath) {
            cell.lab.text = viewModel.cateName
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        // 重置选中销量按钮
        FNToastManager.hide()
        self.btnsView.initStatus()
        
        let cate_id = subVM?.getChildCateIdForIndexPath(indexPath) ?? "140085272"
        let cate_name = subVM?.getChildCateNameForIndexPath(indexPath) ?? "饮用水"
        detailController.cate_id = cate_id
        detailController.cate_name = cate_name
    }
    
}
