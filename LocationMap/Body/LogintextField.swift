//
//  LogintextField.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import UIKit

class LoginTextField: UITextField {
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            layer.cornerRadius = 12
            tintColor = UIColor.black
            backgroundColor = UIColor.bege
        }
    }

    extension LoginTextField {
        
        func customTextRect(forBounds bounds: CGRect) -> CGRect {
            let insetBounds = CGRect(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.size.width - 16, height: bounds.size.height)
            return insetBounds
        }
        
        func customEditingRect(forBounds bounds: CGRect) -> CGRect {
            let insetBounds = CGRect(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.size.width - 16, height: bounds.size.height)
            return insetBounds
        }
    }
