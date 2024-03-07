//
//  NSAttributedString+FSPopoverView.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/24.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import Foundation

extension FSPopoverViewInternalWrapper where Base: NSAttributedString {
    
    static func size(of attributedString: NSAttributedString?, limitedSize: CGSize? = .zero, limitedNumberOfLines: Int = 0) -> CGSize {
        guard let att_string = attributedString, !att_string.string.isEmpty else {
            return .zero
        }
		_ = max(limitedNumberOfLines, 0)
        let constraints: CGSize = {
            if let size = limitedSize, size.width > 0, size.height > 0 {
                return .init(width: ceil(size.width), height: ceil(size.height))
            }
            return CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        }()
        let size = att_string.boundingRect(with: constraints,
                                           options: [.usesLineFragmentOrigin, .usesFontLeading],
                                           context: nil).size
        return .init(width: ceil(size.width), height: ceil(size.height))
    }
}
