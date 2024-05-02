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

class SNSWebViewController: UIViewController, ViewModelBindableType, WKUIDelegate {
    
    var viewModel: SNSWebViewModel!
    private var webView = WKWebView()
    
    private let backButtonImage: UIImage? = {
        return UIImage(named: "arrow_left24")?.withTintColor(.gray_555555, renderingMode: .alwaysOriginal)
    }()

    private let forwardButtonImage: UIImage? = {
        return UIImage(named: "arrow_right")?.withTintColor(.gray_555555, renderingMode: .alwaysOriginal)
    }()

    private let reloadButtonImage: UIImage? = {
        return UIImage(named: "Redo")?.withTintColor(.gray_555555, renderingMode: .alwaysOriginal)
    }()

    private let shareButtonImage: UIImage? = {
        return UIImage(named: "External_Link")?.withTintColor(.gray_555555, renderingMode: .alwaysOriginal)
    }()

    lazy var barBackButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(didTapToolBarBackButton))
    }()

    lazy var barForwardButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: forwardButtonImage, style: .plain, target: self, action: #selector(didTapToolBarForwardButton))
    }()
    
    lazy var reloadButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: reloadButtonImage, style: .plain, target: self, action: #selector(didTapToolBarReloadButton))
    }()

    // customView로 생성하면 마지막에 flexibleSpace가 균등하게 공간을 차지하지 않아서 image로 생성
    lazy var shareButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: shareButtonImage, style: .plain, target: self, action: #selector(didTapToolBarShareButton))
    }()
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupUI()
        setConstraints()
        addBottomToolBar()
        
        guard let url = viewModel.url, !url.isEmpty else { return }
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: viewModel.title)
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
        /// 공간 균등 배분
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let toolbarItems = [
            flexibleSpace,
            barBackButtonItem,
            flexibleSpace,
            flexibleSpace,
            barForwardButtonItem,
            flexibleSpace,
            flexibleSpace,
            reloadButtonItem,
            flexibleSpace,
            flexibleSpace,
            shareButtonItem,
            flexibleSpace
        ]
        
        setToolbarItems(toolbarItems, animated: false)
        
        navigationController?.isToolbarHidden = false
    }
}


extension SNSWebViewController {

    @objc func didTapToolBarBackButton() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc func didTapToolBarForwardButton() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    @objc func didTapToolBarReloadButton() {
        webView.reload()
    }

    @objc func didTapToolBarShareButton() {
        presentShareModal()
    }

    private func presentShareModal() {
        // FIXME: 현재 띄우고 있는 url을 공유
        let shareObject: [Any] = [viewModel.url as Any]
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        //activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}
