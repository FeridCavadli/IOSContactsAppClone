//
//  ContactListViewModel.swift
//  iOSContactsAppClone
//
//  Created by Ferid on 04.07.25.
//

import Foundation
import Contacts

class ContactListViewModel {

    private(set) var sections: [ContactSection] = []
    private var allContacts: [CNContact] = []

    var onDataUpdate: (() -> Void)?

    private let store = CNContactStore()

    func requestAccessAndFetch() {
        store.requestAccess(for: .contacts) { [weak self] granted, _ in
            if granted {
                self?.fetchContacts()
            } else {
                self?.sections = []
                DispatchQueue.main.async {
                    self?.onDataUpdate?()
                }
            }
        }
    }

    private func fetchContacts() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            let keys: [CNKeyDescriptor] = [
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor
            ]

            let request = CNContactFetchRequest(keysToFetch: keys)
            var fetched: [CNContact] = []

            do {
                try self.store.enumerateContacts(with: request) { contact, _ in
                    fetched.append(contact)
                }
            } catch {
                print("Failed to fetch contacts: \(error)")
            }

            self.allContacts = fetched
            self.sections = self.group(fetched)

            DispatchQueue.main.async {
                self.onDataUpdate?()
            }
        }
    }

    private func group(_ contacts: [CNContact]) -> [ContactSection] {
        let grouped = Dictionary(grouping: contacts) { contact in
            let name = contact.givenName.isEmpty ? "#" : String(contact.givenName.prefix(1)).uppercased()
            return name
        }

        let sortedKeys = grouped.keys.sorted()
        return sortedKeys.map { key in
            ContactSection(title: key, contacts: grouped[key]!.sorted { $0.givenName < $1.givenName })
        }
    }

    func search(_ text: String) {
        if text.isEmpty {
            sections = group(allContacts)
        } else {
            let filtered = allContacts.filter {
                $0.givenName.lowercased().contains(text.lowercased()) ||
                $0.familyName.lowercased().contains(text.lowercased())
            }
            sections = group(filtered)
        }
        onDataUpdate?()
    }

    func contact(at indexPath: IndexPath) -> CNContact {
        return sections[indexPath.section].contacts[indexPath.row]
    }
}
