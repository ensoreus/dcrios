//
//  SingleInstance.swift
//  Decred Wallet
//
//  Created by Suleiman Abubakar on 19/09/2018.
//  Copyright © 2018 The Decred developers. All rights reserved.
//

import Foundation
import UIKit
import Mobilewallet
public class SingleInstance{
    var wallet: MobilewalletLibWallet?
    public class var shared: SingleInstance {
        struct Static {
            static let instance: SingleInstance = SingleInstance()
        }
        return Static.instance
    }
    
    
}
