//
//  ConversationTableViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 12/11/24.
//

import UIKit
import WebKit

class ConversationViewController: BaseTableViewController {
    let dataManager = ConversationDataManager.shared

    override func viewDidLoad() {
        dataSource = dataManager
        dataSource = dataManager
        super.viewDidLoad()
        dataManager.delegate = self
    }

    override func registerCells() {
        tableView.register(WebViewCell.self, forCellReuseIdentifier: WebViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 // Estimate to improve performance
    }
}

extension ConversationViewController: ControllerDelegate {
    func dataUpdated() {
        tableView.reloadData()
    }
    
    func controllerDidSelect(_ selection: Int, title: String) {
        // We don't do shit here
    }

    func tableViewHeightUpdated() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

class ConversationDataManager: BaseDataManager {
    static let shared = ConversationDataManager(configurator: Configurator.shared,
                                                service: FreeScoutService.shared)
    var conversation: Conversation?
    private var cellHeights: [IndexPath: CGFloat] = [:]

    private override init(configurator: Configurator, service: FreeScoutService) {
        super.init(configurator: configurator, service: service)
    }

    func getConversation(_ id: Int) {
        Task {
            let object = try await service.fetchConversation(id)
            conversation = object
            await notifyDataUpdated()
        }
    }

    func clear() {
        conversation = nil
    }
}

extension ConversationDataManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WebViewCell.reuseIdentifier, for: indexPath) as? WebViewCell
        else { return UITableViewCell() }

        let thread = conversation?.embedded.threads[indexPath.section]
        if let body = thread?.body {
            cell.loadHTMLContent(body)
        }

        // Handle dynamic height update
        cell.onHeightChange = { [weak self] height in
            guard let self = self else { return }
            delegate?.tableViewHeightUpdated()
        }

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return conversation?.embedded.threads.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
}

class WebViewCell: UITableViewCell {
    static let reuseIdentifier = "WebViewCell"
    private var webView: WKWebView!

    // Callback for notifying height changes
    var onHeightChange: ((CGFloat) -> Void)?

    // Height constraint
    private var webViewHeightConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWebView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupWebView() {
        webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(webView)

        // Auto Layout constraints
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        // Height constraint for dynamic resizing
        webViewHeightConstraint = webView.heightAnchor.constraint(equalToConstant: 0)
        webViewHeightConstraint.isActive = true
    }

    func loadHTMLContent(_ html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }
}

// MARK: - WKNavigationDelegate to Detect Content Height
extension WebViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Calculate the content height using JavaScript
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] result, error in
            guard let self = self, let height = result as? CGFloat, error == nil else { return }

            // Update the height constraint
            self.webViewHeightConstraint.constant = height
            self.onHeightChange?(height)
        }
    }
}
