//
//  Alert.swift
//  ExchangeRateApplication
//
//  Created by Stanislau on 17.04.2018.
//  Copyright © 2018 Stanislau. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    class func showBasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
