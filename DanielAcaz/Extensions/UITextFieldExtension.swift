//
//  UITextFieldExtensions.swift
//  DanielAcaz
//
//  Created by Daniel Acaz on 04/05/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func alertIfEmpty(){
        if (self.text?.isEmpty)! {
            let border = CALayer()
            border.borderColor =  UIColor.red.cgColor
            border.frame = CGRect(x: 0, y:0, width:  self.frame.size.width, height: self.frame.size.height)
            border.borderWidth = 1.0
            border.cornerRadius = 5
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    }
}
