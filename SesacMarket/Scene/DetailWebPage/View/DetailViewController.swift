//
//  DetailViewController.swift
//  SesacMarket
//
//  Created by 서동운 on 9/11/23.
//

import UIKit
import WebKit

class DetailViewController: BaseViewController, WKUIDelegate {
    var webView: WKWebView
    let viewModel: DetailViewModel
    lazy var indicator = UIActivityIndicatorView(style: .large)
   
    lazy var wishBarButton = UIBarButtonItem(image: UIImage(systemName: Image.wish), style: .plain, target: self, action: #selector(wishButtonDidTapped))
    
    init(item: Item) {
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
        webView.navigationDelegate = self
        webView.allowsLinkPreview = true
        webView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isWished = viewModel.isWished()
        updateWishButton(isWished: isWished)
    }
    
    override func configureViews() {
        super.configureViews()
        
        view.addSubview(webView)
        view.addSubview(indicator)
        title = viewModel.item.validatedTitle
        navigationItem.rightBarButtonItem = wishBarButton
        navigationItem.backButtonTitle = "검색"
        
        updateWishButton(isWished: viewModel.item.isWished)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    @objc func wishButtonDidTapped() {
        do {
            let isWished = try viewModel.wishButtonAction()
            updateWishButton(isWished: isWished)
        } catch {
            showAlertMessage(title: "좋아요 저장 실패", message: (error as? SesacError)?.message)
        }
    }
    
    func updateWishButton(isWished: Bool) {
        wishBarButton.image = UIImage(systemName: isWished ? Image.wishFill : Image.wish)
    }
}

extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        indicator.isHidden = true
        guard let title = webView.title else { return }
        navigationItem.title = title
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
}
