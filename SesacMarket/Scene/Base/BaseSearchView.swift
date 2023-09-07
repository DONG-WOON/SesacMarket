//
//  SearchView.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit

final class BaseSearchView: UIView, UIConfigurable {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
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
        addSubview(tableView)
    }
    
    func setAttributes() {
        searchBar.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
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
