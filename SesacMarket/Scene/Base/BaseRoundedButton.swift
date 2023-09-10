//
//  BaseRoundedButton.swift
//  SesacMarket
//
//  Created by 서동운 on 9/10/23.
//

import UIKit

final class BaseRoundedView: UIView, UIConfigurable {
    
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        setAttributes()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutIfNeeded()
        self.rounded(radius: 10)
        self.makeBorder(width: 1, color: .gray)
    }
    
    func configureViews() {
        addSubview(label)
    }
    
    func setAttributes() {
        backgroundColor = .systemBackground
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
    }
    
    func setConstraints() {
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    func setTitle(_ title: String?) {
        label.text = title
    }
}
