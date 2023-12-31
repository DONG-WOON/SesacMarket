//
//  BaseItemCell.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit
import Kingfisher
import SkeletonView

class BaseItemCell: UICollectionViewCell, UIConfigurable {
    
    var wishButtonAction: (() -> Void)?
    
    let itemImageView = UIImageView()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let wishButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        setAttributes()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        itemImageView.image = nil
        mallNameLabel.text = nil
        titleLabel.text = nil
        priceLabel.text = nil
    }
    
    @objc func wishButtonDidTapped() {
        wishButtonAction?()
    }
    
    func configureViews() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
        contentView.addSubview(wishButton)
    }
    
    func setAttributes() {
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.rounded()
        itemImageView.isSkeletonable = true
        
        mallNameLabel.font = .systemFont(ofSize: 12)
        mallNameLabel.textColor = .gray
        mallNameLabel.lineBreakMode = .byTruncatingMiddle
        mallNameLabel.textAlignment = .left
        mallNameLabel.numberOfLines = 1
        mallNameLabel.isSkeletonable = true
        
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.isSkeletonable = true
        
        priceLabel.font = .boldSystemFont(ofSize: 15)
        priceLabel.textColor = .label
        priceLabel.textAlignment = .left
        priceLabel.numberOfLines = 1
        priceLabel.adjustsFontForContentSizeCategory = true
        priceLabel.isSkeletonable = true
        
        wishButton.tintColor = .black
        wishButton.backgroundColor = .white
        wishButton.addTarget(self, action: #selector(wishButtonDidTapped), for: .touchUpInside)
        wishButton.isSkeletonable = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        wishButton.layoutIfNeeded()
        wishButton.rounded(radius: wishButton.bounds.width / 2)
    }
    
    func setConstraints() {
    
        itemImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(itemImageView.snp.width)
        }
    
        mallNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
            make.top.equalTo(itemImageView.snp.bottom).offset(3)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
            make.top.equalTo(mallNameLabel.snp.bottom).offset(3)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.bottom.lessThanOrEqualToSuperview().inset(5)
        }
        
        wishButton.snp.makeConstraints { make in
            make.height.width.equalTo(itemImageView.snp.width).multipliedBy(0.2)
            make.trailing.bottom.equalTo(itemImageView).inset(5)
        }
    }
}
