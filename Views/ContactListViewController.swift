//
//  ContactListViewController.swift
//  iOSContactsAppClone
//
//  Created by Ferid on 04.07.25.
//

import UIKit
import Contacts

class ContactListViewController: UIViewController {

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let viewModel = ContactListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        view.backgroundColor = .white
        setupUI()
        bind()
        viewModel.requestAccessAndFetch()
    }

    private func setupUI() {
        searchBar.delegate = self

        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")

        tableView.delegate = self
    }




    private func bind() {
        viewModel.onDataUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


extension ContactListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].contacts.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].title
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = viewModel.contact(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        cell.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        cell.imageView?.image = UIImage(systemName: "person.crop.circle")

        if let imageData = contact.thumbnailImageData,
           let image = UIImage(data: imageData) {
            cell.imageView?.image = image
        }
        let size = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        cell.imageView?.image?.draw(in: CGRect(origin: .zero, size: size))
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        cell.imageView?.layer.cornerRadius = 15
        cell.imageView?.clipsToBounds = true

        return cell
    }

}

extension ContactListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search("")
    }
}
extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = viewModel.contact(at: indexPath)
        let detailVC = ContactDetailViewController(contact: contact)
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
