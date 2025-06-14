//
//  PreferencesDataManager.swift
//  Kami
//
//  Created by Jon Alaniz on 1/1/25.
//

import UIKit

enum PreferencesSection: Int, CaseIterable {
    case signIn = 0
}

enum SignInRow: Int, CaseIterable {
    case url = 0
    case apiKey
}

class PreferencesDataManager: BaseDataManager {
    static let shared = PreferencesDataManager()

    private var configuration: Configuration?
    private var urlString: String?
    private var key: String?

    var isSignedIn: Bool {
        return configuration != nil
    }

    private init() {
        super.init()
        configuration = configurator.configuration
        urlString = configurator.secret?.url.absoluteString
        key = configurator.secret?.key
    }

    @objc func inputText(_ sender: UITextField) {
        guard let text = sender.text else { return }
        switch sender.isSecureTextEntry {
        // Password TextField
        case true: key = text

        // URL TextField
        case false: urlString = text
        }

        // Tell our delegate data has been updated
        if hasValidCredentials() { delegate?.dataUpdated() }
    }

    func hasValidCredentials() -> Bool {
        return isValidKey(key) && isValidURL(urlString) == true
    }

    func signIn() {
        // TODO: Implement url/key validation
        // Here we need to make a call for just the header data
        // at the server and get a 200 response

        // Save the data
        let secret = Secret(url: URL(string: urlString!)!, key: key!)
        configurator.save(secret: secret)

        // Notify the delegate
        delegate?.dataUpdated()
    }

    func signOut() {
        key = nil
        urlString = nil
        configurator.deleteSecret()
        configuration = nil
        delegate?.dataUpdated()
    }

    // Validate the API Key is a valid 128-Bit key (32 characters long)
    private func isValidKey(_ key: String?) -> Bool {
        guard let key = key else { return false }
        return key.count == 32
    }

    private func isValidURL(_ url: String?) -> Bool {
        guard let url = url,
              let _ = URL(string: url)
        else { return false }
        return true
    }
}

extension PreferencesDataManager: UITableViewDataSource {
    // MARK: - UITableView Functions

    func numberOfSections(in tableView: UITableView) -> Int {
        return PreferencesSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = PreferencesSection(rawValue: section)
        else { return 0 }

        switch section {
        case .signIn: return SignInRow.allCases.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = PreferencesSection(rawValue: indexPath.section)
        else { return UITableViewCell() }

        switch section {
        case .signIn: return signInCellFor(indexPath.row)
        }
    }

    // MARK: - Helper Functions
    private func signInCellFor(_ row: Int) -> UITableViewCell {
        let type: TextFieldType
        let content: String?

        guard let row = SignInRow(rawValue: row)
        else { return UITableViewCell() }

        switch row {
        case .url:
            type = .URL
            content = configurator.secret?.url.absoluteString
        case .apiKey:
            type = .password
            content = configurator.secret?.key
        }

        return createInputCell(type: type, content: content)
    }

    private func createInputCell(type: TextFieldType, content: String?) -> UITableViewCell {
        let textField = TextFieldFactory.textField(type: type, placeholder: type.placeholder())
        textField.text = content
        textField.delegate = self
        textField.textColor = isSignedIn ? .text : .headerText
        textField.isEnabled = !isSignedIn

        switch type {
        case .URL:
            textField.text = urlString
        case .password:
            textField.text = key
        default:
            break
        }

        textField.addTarget(self,
                            action: #selector(inputText),
                            for: .editingChanged)

        return InputCell(textField: textField)
    }
}

extension PreferencesDataManager: UITextFieldDelegate {
    // Dismiss the keyboard when the return field is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
