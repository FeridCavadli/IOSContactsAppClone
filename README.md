Language: Swift
Frameworks: UIKit, Contacts
Design: Programmatic UI (no Storyboards)
Architecture: MVVM (Model-View-ViewModel) 

Steps to run the Project --->
   - Open `ContactsAppClone.xcodeproj` in Xcode (version 14 or later).
   - Build and run the project using a simulator or real iOS device.
   - When prompted, grant access to your device's contacts.
   - The app will display your contacts grouped alphabetically.
   - Tap on any contact to view detailed information including name, phone numbers, email addresses, and profile photo.

ContactsAppClone/
├── Model/
│   └── ContactSection.swift
├── ViewModel/
│   └── ContactListViewModel.swift
├── View/
│   ├── ContactListViewController.swift
│   └── ContactDetailViewController.swift
├── Resources/
│   └── Info.plist
├── AppDelegate.swift / SceneDelegate.swift
├── README.md
└── ContactsAppClone.xcodeproj

