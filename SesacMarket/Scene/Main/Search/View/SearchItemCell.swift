//
//  SearchItemCell.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import UIKit
import Kingfisher

final class SearchItemCell: BaseItemCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func update(item: Item) {
        mallNameLabel.text = item.mallName
        titleLabel.text = item.validatedTitle
        priceLabel.text = item.decimalPrice
        wishButton.setImage(UIImage(systemName: !item.isWished ? Image.wish : Image.wishFill), for: .normal)
        itemImageView.kf.setImage(with: item.originalImageURL)
    }
}
