//
//  ContactDetailViewController.swift
//  iOSContactsAppClone
//
//  Created by Ferid on 04.07.25.
//

import UIKit
import Contacts

class ContactDetailViewController: UIViewController {

    private let contact: CNContact

    init(contact: CNContact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
        title = "Contact Details"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .center

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])


        let imageView = UIImageView()
        if let imageData = contact.thumbnailImageData {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120),
        ])


        let nameLabel = UILabel()
        nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        nameLabel.font = UIFont.systemFont(ofSize: 33, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0
        stackView.addArrangedSubview(nameLabel)


        if !contact.phoneNumbers.isEmpty {
            let phoneTitle = UILabel()
            phoneTitle.text = "Phone Numbers"
            phoneTitle.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            phoneTitle.textColor = .secondaryLabel
            stackView.addArrangedSubview(phoneTitle)

            for number in contact.phoneNumbers {
                let label = UILabel()
                label.text = number.value.stringValue
                label.font = UIFont.systemFont(ofSize: 17)
                label.textColor = .systemBlue
                label.numberOfLines = 1
                stackView.addArrangedSubview(label)
            }
        }

            if !contact.emailAddresses.isEmpty {
            let emailTitle = UILabel()
            emailTitle.text = "Email Addresses"
            emailTitle.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            emailTitle.textColor = .secondaryLabel
            stackView.addArrangedSubview(emailTitle)

            for email in contact.emailAddresses {
                let label = UILabel()
                label.text = String(email.value)
                label.font = UIFont.systemFont(ofSize: 17)
                label.textColor = .systemBlue
                label.numberOfLines = 1
                stackView.addArrangedSubview(label)
            }
        }
    }
}
