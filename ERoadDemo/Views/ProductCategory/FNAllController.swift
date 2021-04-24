//
//  FNAllController.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/15.
//

import UIKit



class FNAllController: FNBaseViewController {
    
    var productVM: FNProductsCollectionVM? {
        didSet {
            guard let vm = productVM else { return }
            vm.fnrequest_getGoodsFirstGrade { (isSuccess) in
                if isSuccess {
                    self.topView.reloadData()
                    // 默认选中第一个
                    DispatchQueue.main.async {
                        self.topView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                        self.collectionView(self.topView, didSelectItemAt: IndexPath(row: 0, section: 0))
                    }
                }
            }
        }
    }
    
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        setup()
        productVM = FNProductsCollectionVM()
    }
    
    
    private func setup() {
        view.addSubview(searchBtn)
        searchBtn.addTarget(self, action: #selector(searchAreaDidClicked(_:)), for: .touchUpInside)
        
        searchBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(statusBarHieght + 10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBtn.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        topView.dataSource = self
        topView.delegate = self
        topView.register(FNGoodsFirstGradeCell.self, forCellWithReuseIdentifier: NSStringFromClass(FNGoodsFirstGradeCell.self))
        
        addChild(subController)
        view.addSubview(subController.view)
        subController.didMove(toParent: self)
        
        subController.view.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    //MARK: - action
    @objc private func searchAreaDidClicked(_ sender: UIButton) {
        print(#function)
    }

    
    //MARK: - lazy loading
    private lazy var searchBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.white
        
        let lab = UILabel()
        lab.text = fn_string(key: "all_search_title")
        lab.textColor = lightGrayTextColor
        lab.font = UIFont.systemFont(ofSize: 13)
        btn.addSubview(lab)
        
        let imgView = UIImageView(image: fn_image(name: "category_search"))
        btn.addSubview(imgView)
        
        lab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        imgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(lab)
            make.width.height.equalTo(30)
            make.right.equalToSuperview().offset(-10)
        }
        return btn
    }()
    
    private lazy var topView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 70)
        let v = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        v.backgroundColor = categoryColor
        v.alwaysBounceHorizontal = true
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return v
    }()
    
    private lazy var subController: FNGoodsSubController = {
        let vc = FNGoodsSubController()
        return vc
    }()
    
}

extension FNAllController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productVM?.firstGradeViewModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FNGoodsFirstGradeCell.self), for: indexPath) as! FNGoodsFirstGradeCell
        
        if let viewModel = productVM?.getViewModelWithIndexPath(indexPath) {
            cell.viewModel = viewModel
        }
        return cell
    }
}

extension FNAllController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndexPath == indexPath {
            return
        }
        selectedIndexPath = indexPath
        let cell = collectionView.cellForItem(at: indexPath) as! FNGoodsFirstGradeCell
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        subController.cate_id = cell.viewModel?.cateID
    }
}
