//
//  SearchView.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit

final class BaseView: UIView, UIConfigurable, KeyboardLayoutProtocol {
    
    weak var collectionViewDataSource: UICollectionViewDataSource?
    weak var collectionViewDelegate: UICollectionViewDelegate?
    
    weak var keyboardWillHideToken: NSObjectProtocol?
    weak var keyboardWillShowToken: NSObjectProtocol?
    
    let searchBar = UISearchBar()
    let collectionView: UICollectionView
    
    var keyboardHeight: CGFloat = 0 {
        didSet {
            setCollectionViewConstraints(constant: keyboardHeight)
        }
    }
    
    var indexPathsForVisibleItems: [IndexPath] {
        return collectionView.indexPathsForVisibleItems
    }
    
    init(scene: Scene) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: BaseCompositionalLayout.createLayout(scene: scene))
        super.init(frame: .zero)
        self.isSkeletonable = true
        collectionView.isSkeletonable = true
        configureViews()
        setAttributes()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadItems(at indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func configureViews() {
        addSubview(searchBar)
        addSubview(collectionView)
    }
    
    func setAttributes() {
        searchBar.backgroundColor = .systemBackground
        searchBar.tintColor = .label
        searchBar.setValue("취소", forKey: "cancelButtonText")
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        setCollectionViewConstraints(constant: keyboardHeight)
    }
    
    fileprivate func setCollectionViewConstraints(constant: CGFloat) {
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            
            if #available(iOS 15.0, *) {
                make.bottom.equalTo(keyboardLayoutGuide.snp.top)
            } else {
                make.bottom.equalTo(safeAreaLayoutGuide).inset(keyboardHeight)
            }
        }
    }
}
