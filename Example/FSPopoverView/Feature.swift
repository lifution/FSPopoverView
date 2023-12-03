//
//  Feature.swift
//  FSPopoverView_Example
//
//  Created by Sheng on 2023/12/3.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

enum Feature {
    
    case copy
    case message
    case db
    case qr
    case settings
    case forward
    case delete
    case quote
    case translate
    
    var image: UIImage? {
        switch self {
        case .copy:
            return .init(named: "copy")
        case .message:
            return .init(named: "message")
        case .db:
            return .init(named: "db")
        case .qr:
            return .init(named: "qr")
        case .settings:
            return .init(named: "settings")
        case .forward:
            return .init(named: "forward")
        case .delete:
            return .init(named: "delete")
        case .quote:
            return .init(named: "quote")
        case .translate:
            return .init(named: "translate")
        }
    }
    
    var title: String {
        switch self {
        case .copy:
            return "Copy Contents"
        case .message:
            return "Message"
        case .db:
            return "DataBase"
        case .qr:
            return "QR Code"
        case .settings:
            return "Settings"
        case .forward:
            return "Forward"
        case .delete:
            return "Delete"
        case .quote:
            return "Quote"
        case .translate:
            return "Translate"
        }
    }
}
