//
//  LoginViewController.swift
//  Adamant-ios
//
//  Created by Anokhov Pavel on 05.01.2018.
//  Copyright © 2018 Adamant. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	// MARK: - Dependencies
	var accountService: AccountService!
	var apiService: ApiService!
	
	
	// MARK: - IBOutlets
	@IBOutlet weak var passphraseTextField: UITextField!
	@IBOutlet weak var newPassphraseTextArea: UITextView!
	
	
	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		passphraseTextField.text = ""
		newPassphraseTextArea.text = ""
    }

	
	// MARK: - IBActions
	@IBAction func login(_ sender: Any) {
		guard let passphrase = passphraseTextField?.text else {
			return
		}
		
		accountService.login(passphrase: passphrase, loginCompletionHandler: nil)
	}
	
	@IBAction func createNewPassphrase(_ sender: Any) {
		
	}
}