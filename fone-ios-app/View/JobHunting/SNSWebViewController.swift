//
//  SNSWebViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/15/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import WebKit

class SNSWebViewController: UIViewController, WKUIDelegate/*, WKNavigationDelegate*/ {
    
//    var viewModel: SNSWebViewModel!
    private var webView = WKWebView()
    
    private lazy var backButtonImage: UIImage? = {
        return UIImage(named: "arrow_left24")?.withTintColor(.gray_555555, renderingMode: .alwaysOriginal)
    }()

    private lazy var forwardButtonImage: UIImage? = {
        return UIImage(named: "arrow_right")?.withTintColor(.gray_555555, renderingMode: .alwaysOriginal)
    }()

    private lazy var reloadButtonImage: UIImage? = {
        return UIImage(named: "Redo")?.withTintColor(.gray_555555, renderingMode: .alwaysOriginal)
    }()

    private lazy var shareButtonImage: UIImage? = {
        return UIImage(named: "External_Link")?.withTintColor(.gray_555555, renderingMode: .alwaysOriginal)
    }()

    lazy var barBackButtonItem: UIBarButtonItem = {
        // 주의: UIBarButtonItem을 생성할 때 CustomView로 button을 넣을경우 하나만 표출되므로 image로 넣어서 사용
        return UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(didTapToolBarBackButton))
//            .then {
//            $0.isEnabled = webView.canGoBack
//        }
    }()
//    var barBackButtonItem: UIBarButtonItem {
//        let button = UIButton().then {
//            $0.setImage(backButtonImage, for: .normal)
//        }
//        let barButtonItem = UIBarButtonItem(customView: button)
////        barButtonItem.isEnabled = webView.canGoBack
//        barButtonItem.rx.tap.withUnretained(self)
//            .bind { owner, _ in
//                owner.webView.goBack()
//            }.disposed(by: rx.disposeBag)
//        
//        return barButtonItem
//    }

    lazy var barForwardButtonItem: UIBarButtonItem = {
        // 주의: UIBarButtonItem을 생성할 때 CustomView로 button을 넣을경우 하나만 표출되므로 image로 넣어서 사용
//        let button = UIButton().then {
//            $0.setImage(forwardButtonImage, for: .normal)
//        }
//        
//        let barButtonItem = UIBarButtonItem(customView: button)
////        barButtonItem.setBackgroundImage(forwardButtonImage, for: .normal, barMetrics: .default)
////        barButtonItem.setBackgroundImage(backButtonImage?.withTintColor(.red), for: .disabled, barMetrics: .default)
//        barButtonItem.isEnabled = webView.canGoForward
//        return barButtonItem
        
        let buttonItem = UIBarButtonItem(image: forwardButtonImage, style: .plain, target: self, action: #selector(didTapToolBarForwardButton))
//        if webView.canGoForward {
//            buttonItem.isEnabled = true
//            buttonItem.tintColor = .red
//        } else {
//            buttonItem.isEnabled = false
//            buttonItem.tintColor = .yellow
//            buttonItem.image?.withTintColor(.yellow)
//            buttonItem.image?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
//        }
        return buttonItem
    }()
    
    lazy var reloadButtonItem: UIBarButtonItem = {
        // 주의: UIBarButtonItem을 생성할 때 CustomView로 button을 넣을경우 하나만 표출되므로 image로 넣어서 사용
        return UIBarButtonItem(image: reloadButtonImage, style: .plain, target: self, action: #selector(didTapToolBarReloadButton))
    }()

    lazy var shareButtonItem: UIBarButtonItem = {
        // 주의: UIBarButtonItem을 생성할 때 CustomView로 button을 넣을경우 하나만 표출되므로 image로 넣어서 사용
        return UIBarButtonItem(image: shareButtonImage, style: .plain, target: self, action: #selector(didTapToolBarShareButton))
    }()
    
    @objc func didTapToolBarBackButton() {
        // override this method
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc func didTapToolBarForwardButton() {
        // override this method
        if webView.canGoForward {
            webView.goForward()
        }
    }
    @objc func didTapToolBarReloadButton() {
        // override this method
        webView.reload()
    }

    @objc func didTapToolBarShareButton() {
        // override this method
    }
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupUI()
        setConstraints()
        addBottomToolBar()
        
        let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "개인 SNS")
        navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(
            type: .close,
            viewController: self
        )
        navigationItem.hidesBackButton = true
    }
    
    private func setupUI() {
        view.backgroundColor = .white_FFFFFF
        
        [webView]
            .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top).offset(self.topbarHeight)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addBottomToolBar() {
        let paddingButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        paddingButtonItem.width = 24.0 // TODO: 간격 계산
        toolbarItems = [
            barBackButtonItem,
            paddingButtonItem,
            barForwardButtonItem,
            paddingButtonItem,
            reloadButtonItem,
            paddingButtonItem,
            shareButtonItem
        ]
        
        navigationController?.isToolbarHidden = false
    }
}

