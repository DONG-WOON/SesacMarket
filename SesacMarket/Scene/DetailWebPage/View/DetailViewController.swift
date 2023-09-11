//
//  DetailViewController.swift
//  SesacMarket
//
//  Created by 서동운 on 9/11/23.
//

import UIKit
import WebKit

class DetailViewController<T: Product>: BaseViewController, WKUIDelegate {
    var webView: WKWebView
    let viewModel: DetailViewModel<T>
   
    lazy var wishBarButton = UIBarButtonItem(image: UIImage(systemName: Image.wish), style: .plain, target: self, action: #selector(wishButtonDidTapped))
    
    init(item: T) {
        self.viewModel = DetailViewModel(item: item)
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = viewModel.requestURL()
        
        webView.uiDelegate = self
        webView.allowsLinkPreview = true
        webView.load(request)
    }
    
    override func configureViews() {
        view.addSubview(webView)
        title = viewModel.item.validatedTitle
        navigationItem.rightBarButtonItem = wishBarButton
        navigationItem.backButtonTitle = "검색"
        updateWishButton(isWished: viewModel.item.isWished)
    }
    
    override func setAttributes() {

    }
    
    override func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func wishButtonDidTapped() {
        do {
            let isWished = try viewModel.wishButtonAction()
            updateWishButton(isWished: isWished)
        } catch {
            showAlertMessage(title: error.message)
        }
    }
    
    func updateWishButton(isWished: Bool) {
        wishBarButton.image = UIImage(systemName: isWished ? Image.wishFill : Image.wish)
    }
}
