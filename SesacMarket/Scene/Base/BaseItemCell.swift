//
//  BaseItemCell.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import UIKit
import Kingfisher

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
        
    }
    
    @objc func wishButtonDidTapped() {
        wishButtonAction?()
    }
    
    func configureViews() {
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
        itemImageView.addSubview(wishButton)
        contentView.addSubview(wishButton)
    }
    
    func setAttributes() {
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.rounded()
        
        mallNameLabel.font = .systemFont(ofSize: 12)
        mallNameLabel.textColor = .gray
        mallNameLabel.lineBreakMode = .byTruncatingMiddle
        mallNameLabel.textAlignment = .left
        mallNameLabel.numberOfLines = 1
        mallNameLabel.adjustsFontForContentSizeCategory = true
    
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontForContentSizeCategory = true
        
        // ⭐️ TO DO: 가격의 경우 큰 수의 경우 어떻게 보여줄지 ⭐️
        priceLabel.font = .boldSystemFont(ofSize: 15)
        priceLabel.textColor = .label
        priceLabel.textAlignment = .left
        priceLabel.numberOfLines = 1
        priceLabel.adjustsFontForContentSizeCategory = true
        
        wishButton.setImage(UIImage(systemName: Image.wish), for: .normal)

        wishButton.tintColor = .black
        wishButton.backgroundColor = .white
        wishButton.addTarget(self, action: #selector(wishButtonDidTapped), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        wishButton.layoutIfNeeded()
        wishButton.rounded(radius: wishButton.bounds.width / 2)
    }
    
    // ⭐️ TO DO: landscape 모드 대응 ⭐️
    func setConstraints() {
        itemImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(itemImageView.snp.width)
        }
        
        mallNameLabel.setContentHuggingPriority(.required, for: .vertical)
        mallNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
            make.top.equalTo(itemImageView.snp.bottom).offset(3)
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
            make.top.equalTo(mallNameLabel.snp.bottom).offset(3)
        }
        
        priceLabel.setContentHuggingPriority(.required, for: .vertical)
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

extension BaseItemCell {
    func update(item: Item) {
        mallNameLabel.text = item.mallName
        titleLabel.text = item.validatedTitle
        priceLabel.text = item.price
        itemImageView.kf.setImage(with: item.thumbnailURL)
        wishButton.setImage(UIImage(systemName: !item.isWished ? Image.wish : Image.wishFill), for: .normal)
        itemImageView.kf.setImage(with: item.originalImageURL)
    }
}
