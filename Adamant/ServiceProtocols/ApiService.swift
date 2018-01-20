//
//  ApiService.swift
//  Adamant-ios
//
//  Created by Anokhov Pavel on 05.01.2018.
//  Copyright © 2018 Adamant. All rights reserved.
//

import Foundation

protocol ApiService {
	
	// MARK: - Accounts
	
	func getAccount(byPassphrase passphrase: String, completionHandler: @escaping (Account?, AdamantError?) -> Void)
	func getAccount(byPublicKey publicKey: String, completionHandler: @escaping (Account?, AdamantError?) -> Void)
	
	
	// MARK: - Keys
	
	func getPublicKey(byAddress address: String, completionHandler: @escaping (String?, AdamantError?) -> Void)
	func getPublicKey(byPassphrase passphrase: String, completionHandler: @escaping (String?, AdamantError?) -> Void)
	
	
	// MARK: - Transactions
	
	func getTransaction(id: UInt, completionHandler: @escaping (Transaction?, AdamantError?) -> Void)
	func getTransactions(forAccount: String, type: TransactionType, completionHandler: @escaping ([Transaction]?, AdamantError?) -> Void)
	
	
	// MARK: - Funds
	
	func transferFunds(sender: String, recipient: String, amount: UInt, keypair: Keypair, completionHandler: @escaping (Bool, AdamantError?) -> Void)
	
	
	// MARK: - Chats
	
	func getChatTransactions(account: String, height: Int?, offset: Int?, completionHandler: @escaping ([Transaction]?, AdamantError?) -> Void)
	
	/// Send text message
	///   - completionHandler: Contains processed transactionId, if success, or AdamantError, if fails.
	func sendMessage(senderId: String, recipientId: String, keypair: Keypair, message: String, nonce: String, completionHandler: @escaping (UInt?, AdamantError?) -> Void)
}
