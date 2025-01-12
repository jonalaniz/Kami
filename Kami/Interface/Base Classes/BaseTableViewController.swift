//
//  BaseTableViewController.swift
//  Kami
//
//  Created by Jon Alaniz on 12/1/24.
//

import UIKit

class BaseTableViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    var tableView: UITableView!
    var dataSource: UITableViewDataSource?
    var delegate: UITableViewDelegate?
    var titleText: String?
    var tableStyle: UITableView.Style = .plain

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
