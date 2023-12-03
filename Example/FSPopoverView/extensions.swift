//
//  extensions.swift
//  FSPopoverView_Example
//
//  Created by Sheng on 2023/12/3.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import Photos
import Foundation
import FSPopoverView

extension FSPopoverView {
    
    func shot() {
        guard let view = containerView else {
            return
        }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = image {
            PHPhotoLibrary.shared().performChanges({
                if let imageData = image.pngData() {
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: imageData, options: nil)
                }
            }) { (success, error) in
                if let error = error {
                    print("保存图片失败：\(error.localizedDescription)")
                } else {
                    print("图片保存成功")
                }
            }
        }
    }
}
