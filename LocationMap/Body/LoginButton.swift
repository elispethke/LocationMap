//
//  LoginButton.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 12
        tintColor = UIColor.white
        backgroundColor = UIColor.begeDark
    }
}
