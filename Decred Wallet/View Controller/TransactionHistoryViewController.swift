//
//  TransactionHistoryViewController.swift
//  Decred Wallet
//
//  Created by rails on 23/05/18.
//  Copyright © 2018 The Decred developers. All rights reserved.
//

import UIKit

struct TransactionHistoryItem{
    var status: String?
    var txType: String?
    var amount: String?
    var date : String?
}

protocol TransactionsHistoryItemProviderProtocol {
    func itemsCount() -> Int
    func historyItemBy(index:Int) -> TransactionHistoryItem
    func prepare()
}

class TransactionsHistoryItemProvider : NSObject, TransactionsHistoryItemProviderProtocol, WalletGetTransactionsResponseProtocol {
    var transactionItems : [TransactionHistoryItem]
    var transactions: GetTransactionResponse?
    
    override init() {
        transactionItems = [TransactionHistoryItem]()
    }
    
    func onResult(_ json: String!) {
        do{
            transactions = try JSONDecoder().decode(GetTransactionResponse.self, from:json.data(using: .utf8)!)
            for transactionPack in (transactions?.Transactions!)!{
                transactionItems.append(wrap(item:transactionPack))
            }
        }catch let error{
            print(error)
        }
    }
    
    func prepare(){
        AppContext.instance.decrdConnection?.addObserver(transactionsHistoryObserver: self)
        AppContext.instance.decrdConnection?.fetchTransactions()
    }
    
    func itemsCount() -> Int{
        return (transactions?.Transactions?.count)!
    }
    
    func historyItemBy(index:Int) -> TransactionHistoryItem{
        return transactionItems[index]
    }
    
    func wrap(item:Transaction) -> TransactionHistoryItem{
        var txItem = TransactionHistoryItem()
        txItem.amount = "\(item.dcrAmount).000000 DCR"
        txItem.status = item.Status
        txItem.txType = item.Type
        txItem.date = format(timestamp:item.Timestamp)
        return txItem
    }
    
    func format(timestamp:UInt64) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return formatter.string(from: date)
    }
}

class TransactionHistoryViewController: UIViewController {
    weak var delegate: LeftMenuProtocol?
    var contentProvider : TransactionsHistoryItemProviderProtocol?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFilter: DropMenuButton!
    
//    var dic1 = [ "status":"Pending", "type" : "Credit", "amount" : "112.000000 DCR","date" : "23 Mar, 2018 10:30 pm" ] as Dictionary?
//    var dic2 = [ "status":"Confirmed", "type" : "Debit", "amount" : "24.000000 DCR","date" : "23 Mar, 2018 10:30 pm" ] as Dictionary?
//    var dic3 = [ "status":"Confirmed", "type" : "Debit", "amount" : "26.000000 DCR","date" : "23 Mar, 2018 10:30 pm" ] as Dictionary?
//    var dic4 = [ "status":"Confirmed", "type" : "Debit", "amount" : "72.000000 DCR","date" : "23 Mar, 2018 10:30 pm" ] as Dictionary?
//    var dic5 = [ "status":"Confirmed", "type" : "Credit", "amount" : "92.000000 DCR","date" : "23 Mar, 2018 10:30 pm" ] as Dictionary?
    
    let filterMenu = ["ALL", "Regular", "Ticket", "Votes", "Revokes", "Sent"] as [String]
    
//    var mainContens = [Dictionary<String, String>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        contentProvider = TransactionsHistoryItemProvider()
        contentProvider?.prepare()
        
         btnFilter.initMenu(filterMenu) {(index, value) in
            print("index : \(index), Value : \(value)")
         }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.navigationItem.title = "History"
    }
}

   // MARK: - Table Delegates

extension TransactionHistoryViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.contentProvider?.itemsCount())!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        tableView.register(UINib(nibName: TransactionHistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TransactionHistoryTableViewCell.identifier)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TransactionHistoryTableViewCell") as! TransactionHistoryTableViewCell
        
        let data = TransactionTableViewCellData(data: (contentProvider?.historyItemBy(index: indexPath.row))!)
        cell.setData(data)
        return cell
    }
}
