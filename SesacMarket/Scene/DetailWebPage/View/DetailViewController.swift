//
//  DetailViewController.swift
//  SesacMarket
//
//  Created by 서동운 on 9/11/23.
//

import UIKit
import WebKit
import RealmSwift
import RxSwift

class DetailViewController: BaseViewController, WKUIDelegate {

    let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    var webView: WKWebView
    lazy var indicator = UIActivityIndicatorView(style: .large)
    lazy var wishBarButton = UIBarButtonItem(image: UIImage(systemName: Image.wish), style: .done, target: self, action: #selector(wishButtonDidTapped))
    
    init(item: Item) {
        self.viewModel = DetailViewModel(item: BehaviorSubject(value: item))
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = item.validatedTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsLinkPreview = true
        
        viewModel.requestURL()
            .take(1)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] request in
                self?.webView.load(request)
            })
            .disposed(by: disposeBag)
        
        viewModel.item
            .bind(onNext: { [weak self] item in
                self?.updateWishButton(isWished: item.isWished)
                print(#function, item.isWished)
            })
            .disposed(by: disposeBag)
            
        viewModel.itemIsWished
            .asSignal(onErrorJustReturn: false)
            .asObservable()
            .subscribe(onNext: { [weak self] isWished in
                self?.updateWishButton(isWished: isWished)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.checkItemIsExistInWishItems()
    }
    
    override func configureViews() {
        super.configureViews()
        
        view.addSubview(webView)
        view.addSubview(indicator)
        
        navigationItem.rightBarButtonItem = wishBarButton
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
            try viewModel.toggleWishStatus()
        } catch {
            showAlertMessage(title: (error as? SesacError)!.message)
        }
    }
    
    private func updateWishButton(isWished: Bool) {
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
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
}
