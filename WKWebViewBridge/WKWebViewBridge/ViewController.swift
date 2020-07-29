//
//  ViewController.swift
//  WKWebViewBridge
//
//  Created by Park GilNam on 2020/07/29.
//  Copyright © 2020 swieeft. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webViewBackgroundView: UIView!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        load()
    }

    func setWebView() {
        let contentController = WKUserContentController()
        
        // Bridge 등록
        contentController.add(self, name: "back")
        contentController.add(self, name: "outLink")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        webViewBackgroundView.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: webViewBackgroundView.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewBackgroundView.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: webViewBackgroundView.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: webViewBackgroundView.trailingAnchor).isActive = true
    }

    func load() {
        if let url = Bundle.main.url(forResource: "Example", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "back":
            let alert = UIAlertController(title: nil, message: "Back 버튼 클릭", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        case "outLink":
            guard let outLink = message.body as? String, let url = URL(string: outLink) else {
                return
            }
            
            let alert = UIAlertController(title: "OutLink 버튼 클릭", message: "URL : \(outLink)", preferredStyle: .alert)
            let openAction = UIAlertAction(title: "링크 열기", style: .default) { _ in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(openAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
}
