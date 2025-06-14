//
//  ConversationBodyCell.swift
//  Kami
//
//  Created by Jon Alaniz on 12/17/24.
//

import UIKit
import WebKit

class ConversationBodyCell: BaseTableViewCell {
    static let reuseIdentifier = "ConversationBodyCell"

    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private var webViewHeightConstraint: NSLayoutConstraint!
    var onHeightChange: (() -> Void)?

    override func setupViews() {
        webView.navigationDelegate = self
        contentView.addSubview(webView)
    }

    override func setupConstraints() {
        webViewHeightConstraint = webView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webViewHeightConstraint
        ])
    }

    func loadHTMLContent(_ html: String) {
        let styledHTML = generateStyledHTML(from: html)
        webView.loadHTMLString(styledHTML, baseURL: nil)
    }

    func generateStyledHTML(from rawHTML: String) -> String {
        let customCSS = HTMLInjection.customCSS.string()
        let metaTag = HTMLInjection.metaTag.string()

        if let headRange = rawHTML.range(of: "</head>") {
            return rawHTML.replacingCharacters(in: headRange,
                                               with: "\(metaTag)\(customCSS)</head>")
        } else {
            return """
            <html>
            <head>
            \(customCSS)
            \(metaTag)
            </head>
            <body>
            \(rawHTML)
            </body>
            </html>
            """
        }
    }
}

extension ConversationBodyCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(HTMLInjection.customJS.string()) { [weak self] result, _ in
            guard let self = self, let height = result as? CGFloat else { return }
            self.updateWebViewHeight(to: height)
        }
    }

    private func updateWebViewHeight(to height: CGFloat) {
        if webViewHeightConstraint.constant != height {
            webViewHeightConstraint.constant = height
            onHeightChange?()
        }
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction
    ) async -> WKNavigationActionPolicy {
        guard let url = navigationAction.request.url,
              navigationAction.navigationType == .linkActivated
        else { return .allow }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return .cancel
    }
}
