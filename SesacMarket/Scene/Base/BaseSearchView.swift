//
//  SearchView.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit

final class BaseSearchView: UIView, UIConfigurable, KeyboardLayoutProtocol {
    
    
    weak var keyboardWillHideToken: NSObjectProtocol?
    weak var keyboardWillShowToken: NSObjectProtocol?
    
    let searchBar = UISearchBar()
    
    var keyboardHeight: CGFloat = 0 {
        didSet {
            collectionView.snp.remakeConstraints { make in
                make.top.equalTo(searchBar.snp.bottom)
                make.horizontalEdges.equalTo(safeAreaLayoutGuide)
                make.bottom.equalTo(safeAreaLayoutGuide).inset(keyboardHeight)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        setAttributes()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        addSubview(searchBar)
    }
    
    func setAttributes() {
        searchBar.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            if #available(iOS 15.0, *) {
                make.bottom.equalTo(keyboardLayoutGuide.snp.top)
            } else {
                make.bottom.equalTo(safeAreaLayoutGuide)
            }
        }
    }
}
