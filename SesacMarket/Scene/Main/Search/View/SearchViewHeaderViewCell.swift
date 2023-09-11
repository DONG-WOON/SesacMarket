//
//  SearchViewHeaderViewCell.swift
//  SesacMarket
//
//  Created by 서동운 on 9/10/23.
//

import UIKit

class SearchViewHeaderViewCell: UICollectionViewCell, UIConfigurable {
    
    override var isSelected: Bool {
        didSet {
            roundedView.backgroundColor = isSelected ? .label : .systemBackground
            roundedView.label.textColor = isSelected ? .systemBackground : .label
        }
    }
    
    lazy var roundedView = BaseRoundedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        setAttributes()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        roundedView.backgroundColor = .systemBackground
        roundedView.label.textColor = .label
    }
    
    func configureViews() {
        contentView.addSubview(roundedView)
    }
    
    func setAttributes() {
        self.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        roundedView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(5)
            make.center.equalTo(contentView)
        }
    }
    
    func update(sort: Sort) {
        roundedView.setTitle(sort.title)
    }
}
