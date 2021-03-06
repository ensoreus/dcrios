//
//  SecurityViewController.swift
//  Decred Wallet
//
//  Created by Philipp Maluta on 11/6/18.
//  Copyright © 2018 The Decred developers. All rights reserved.
//

import UIKit

class SecurityViewController: UIViewController, SeedCheckupProtocol,StartUpPasswordProtocol {
    var senders: String?
    var pass_pinToVerify: String?
    var seedToVerify: String?
    var pager: UITabBarController?
    
    
    @IBOutlet weak var btnPin: UIButton!
    @IBOutlet weak var btnPassword: UIButton!
    
    @IBAction func onPasswordTab(_ sender: Any) {
        pager?.selectedIndex = 0
        btnPassword.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnPin.backgroundColor = #colorLiteral(red: 0.9449833035, green: 0.9450840354, blue: 0.9490672946, alpha: 1)
    }
    
    @IBAction func onPinTab(_ sender: Any) {
        pager?.selectedIndex = 1
        btnPin.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnPassword.backgroundColor = #colorLiteral(red: 0.9449833035, green: 0.9450840354, blue: 0.9490672946, alpha: 1)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedPager" {
            if(self.seedToVerify != nil){
                print("seed check")
                pager = segue.destination as? UITabBarController
                pager?.tabBar.isHidden = true
                var vc1 = pager?.viewControllers?.first as? SeedCheckupProtocol
                var vc2 = pager?.viewControllers?.last as? SeedCheckupProtocol
                vc1?.seedToVerify = seedToVerify
                vc2?.seedToVerify = seedToVerify
            }
            else{
                
                print("startup check")
                pager = segue.destination as? UITabBarController
                pager?.tabBar.isHidden = true
                var startChecked1 = pager?.viewControllers?.first as? StartUpPasswordProtocol
                var startChecked2 = pager?.viewControllers?.last as? StartUpPasswordProtocol
                print("on pager received \(senders  ??  "nothing too")")
                startChecked2?.senders = senders
                startChecked1?.senders = senders
                if senders == "settingsChangeSpending"{
                    startChecked1?.pass_pinToVerify = pass_pinToVerify
                    startChecked2?.pass_pinToVerify = pass_pinToVerify
                }
            }
            
        }
    }
}
