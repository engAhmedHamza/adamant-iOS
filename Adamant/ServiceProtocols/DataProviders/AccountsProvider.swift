//
//  AccountsProvider.swift
//  Adamant
//
//  Created by Anokhov Pavel on 29.01.2018.
//  Copyright © 2018 Adamant. All rights reserved.
//

import Foundation
import CoreData

enum AccountsProviderResult {
	case success(CoreDataAccount)
    case dummy(DummyAccount)
	case notFound(address: String)
	case invalidAddress(address: String)
    case notInitiated(address: String)
	case serverError(Error)
	case networkError(Error)
	
	var localized: String {
		switch self {
		case .success(_), .dummy(_):
			return ""
			
		case .notFound(let address):
			return String.adamantLocalized.sharedErrors.accountNotFound(address)
			
		case .invalidAddress(let address):
			return String.localizedStringWithFormat(NSLocalizedString("AccountsProvider.Error.AddressNotValidFormat", comment: "AccountsProvider: Address not valid error, %@ for address"), address)
			
        case .notInitiated(_):
            return String.adamantLocalized.sharedErrors.accountNotInitiated
            
		case .serverError(let error):
			return ApiServiceError.serverError(error: error.localizedDescription).localized
			
		case .networkError:
			return String.adamantLocalized.sharedErrors.networkError
		}
	}
}

enum AccountsProviderDummyAccountResult {
    case success(DummyAccount)
    case foundRealAccount(CoreDataAccount)
    case invalidAddress(address: String)
    case internalError(Error)
}

protocol AccountsProvider {
	
	/// Search for fetched account, if not found, asks server for account.
	///
	/// - Returns: Account, if found, created in main viewContext
	func getAccount(byAddress address: String, completion: @escaping (AccountsProviderResult) -> Void)
	
	/* That one bugged. Will be fixed later. Maybe. */
	/// Search for fetched account, if not found, asks server for account.
	///
	/// - Returns: Account, if found, created in main viewContext
//	func getAccount(byPublicKey publicKey: String, completion: @escaping (AccountsProviderResult) -> Void)
	
	/// Check locally if has account with specified address
	func hasAccount(address: String, completion: @escaping (Bool) -> Void)
    
    
    /// Request Dummy account, if account wasn't found or initiated
    func getDummyAccount(for address: String, completion: @escaping (AccountsProviderDummyAccountResult) -> Void)
}

// MARK: - Known contacts
struct SystemMessage {
	let message: AdamantMessage
	let silentNotification: Bool
}

enum AdamantContacts {
    case adamantBountyWallet
    case adamantIco
    case iosSupport
    
    static let systemAddresses: [String] = {
		return [AdamantContacts.adamantIco.name, AdamantContacts.adamantBountyWallet.name]
	}()
	
	static func messagesFor(address: String) -> [String:SystemMessage]? {
		switch address {
		case AdamantContacts.adamantBountyWallet.address, AdamantContacts.adamantBountyWallet.name:
			return AdamantContacts.adamantBountyWallet.messages
			
		case AdamantContacts.adamantIco.address, AdamantContacts.adamantIco.name:
			return AdamantContacts.adamantIco.messages
			
		default:
			return nil
		}
	}
	
	var name: String {
		switch self {
		case .adamantBountyWallet: return NSLocalizedString("Accounts.AdamantTokens", comment: "System accounts: ADAMANT Tokens")
		case .adamantIco: return "Adamant ICO"
		case .iosSupport: return NSLocalizedString("Accounts.iOSSupport", comment: "System accounts: ADAMANT iOS Support")
		}
	}
	
	var address: String {
		switch self {
		case .adamantBountyWallet: return AdamantResources.contacts.adamantBountyWallet
		case .adamantIco: return AdamantResources.contacts.adamantIco
		case .iosSupport: return AdamantResources.contacts.iosSupport
		}
	}
	
	var isReadonly: Bool {
		switch self {
		case .adamantBountyWallet, .adamantIco: return true
		case .iosSupport: return false
		}
	}
	
	var isHidden: Bool {
		switch self {
		case .adamantBountyWallet: return true
		case .adamantIco, .iosSupport: return false
		}
	}
	
	var avatar: String {
		return "avatar_bots"
	}
	
	var messages: [String: SystemMessage] {
		switch self {
		case .adamantBountyWallet:
			return ["chats.welcome_message": SystemMessage(message: AdamantMessage.markdownText(NSLocalizedString("Chats.WelcomeMessage", comment: "Known contacts: Adamant welcome message. Markdown supported.")),
														   silentNotification: true)]
			
		case .adamantIco:
			return [
				"chats.preico_message": SystemMessage(message: AdamantMessage.text(NSLocalizedString("Chats.PreIcoMessage", comment: "Known contacts: Adamant pre ICO message")),
													  silentNotification: true),
				"chats.ico_message": SystemMessage(message: AdamantMessage.markdownText(NSLocalizedString("Chats.IcoMessage", comment: "Known contacts: Adamant ICO message. Markdown supported.")),
												   silentNotification: true)
			]
			
		case .iosSupport:
			return [:]
		}
	}
}
