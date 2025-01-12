//
//  ConfigurationDataManager.swift
//  Kami
//
//  Created by Jon Alaniz on 1/1/25.
//

import UIKit

class PreferencesDataManager: BaseDataManager {
    static let shared = PreferencesDataManager()

    var configuration: Configuration?

    private init() {
        super.init()
        configuration = configurator.getConfiguration()
    }
}

extension PreferencesDataManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textField = TextFieldFactory.textField(type: .URL, placeholder: "FreeScout URL")
        let cell = InputCell(textField: textField)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderFooterView()
        headerView.configure(label: "Sign In", type: .header)

        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = HeaderFooterView()
        headerView.configure(label: "Kami requires a FreeScout insance with the API & Webhooks module enabled.",
                             type: .footer)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
