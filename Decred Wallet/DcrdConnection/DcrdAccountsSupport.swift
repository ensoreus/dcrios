//
//  DcrdAccountsSupport.swift
//  Decred Wallet
//
//  Copyright © 2018 The Decred developers.
//  see LICENSE for details.
//

import Foundation

protocol DcrAccountsManagementProtocol : DcrdBaseProtocol{
    func getAccounts() -> GetAccountResponse?
    func createAccount(name:String, passwd:String) -> Bool
    func getCurrentAddress(account: Int32) -> String
    func getSpendable(account:AccountsEntity, onGotSpendable:(Int64)->Void) throws
}

extension DcrAccountsManagementProtocol{
    func getAccounts() -> GetAccountResponse?{
        var account : GetAccountResponse?
        do{
            let strAccount = try wallet?.getAccounts(0)
            account = try JSONDecoder().decode(GetAccountResponse.self, from: (strAccount?.data(using: .utf8))!)
        } catch let error{
            print(error)
            return nil
        }
        return account
    }
    
    func createAccount(name:String, passwd:String) -> Bool{
        return  (wallet?.nextAccount(name, privPass: passwd.data(using: .utf8)))!
    }
    
    func getCurrentAddress(account: Int32) -> String {
        var result = ""
        do{
            result = (try wallet?.address(forAccount: account))!
        }catch {
            return ""
        }
        return result
    }
    
    func getSpendable(account:AccountsEntity, onGotSpendable:(Int64)->Void) throws{
        let spendable = UnsafeMutablePointer<Int64>.allocate(capacity: 1)
        try wallet?.spendable(forAccount: account.Number, requiredConfirmations: 1, ret0_: spendable)
        onGotSpendable(spendable.pointee)
    }
    
}
