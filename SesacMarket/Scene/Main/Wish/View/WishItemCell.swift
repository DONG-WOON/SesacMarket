//
//  WishItemCell.swift
//  SesacMarket
//
//  Created by 서동운 on 9/8/23.
//

import UIKit

final class WishItemCell: BaseItemCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func update(item: WishItemEntity) {
        mallNameLabel.text = item.mallName
        titleLabel.text = item.title
        priceLabel.text = item.price
        wishButton.setImage(UIImage(systemName: !item.isWished ? Image.wish : Image.wishFill), for: .normal)
        itemImageView.kf.setImage(with: item.originalImageURL)
    }
}
