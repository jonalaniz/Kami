//
//  BaseTableViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 12/1/24.
//

import UIKit


/// A reusable base class for table view controllers.
///
/// `BaseTableViewController` simplifies the creation of table view controllers by
/// managing common configurations such as navigation bar appearance, toolbar setup,
/// table view initialization, and layout constraints. Subclass this to implement custom table views.
class BaseTableViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    var tableView: UITableView!
    var dataSource: UITableViewDataSource?
    var delegate: UITableViewDelegate?
    var titleText: String?
    var tableStyle: UITableView.Style = .plain
    var toolbarColor: UIColor = .subHeaderToolbar
    var toolbarTint: UIColor = .iconsTexts

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupToolbar()
        setupTableView()
        registerCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let indexPath = tableView.indexPathForSelectedRow
        else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func setupView() {
        if let titleText = titleText { title = titleText }
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .background
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupToolbar() {
        let toolbar = navigationController?.toolbar
        toolbar?.setColors(background: toolbarColor, tint: toolbarTint)
        navigationController?.setToolbarHidden(false, animated: true)
    }

    /// Initializes and configures the table view, setting its delegate, data source, and layout constraints.
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: tableStyle)
        tableView.backgroundColor = .background
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        activateFullScreenConstraints(for: tableView)
    }

    func registerCells() {}

    private func activateFullScreenConstraints(for subview: UIView) {
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: view.topAnchor),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            subview.leftAnchor.constraint(equalTo: view.leftAnchor),
            subview.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
