//
//  UIButton+Ext.swift
//  BubbleView
//
//  Created by yilmaz on 16.07.2022.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ backgroundColor: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(.pixel(ofColor: backgroundColor), for: state)
    }
}
