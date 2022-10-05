//
//  JKSanbox.swift
//  JKSanbox
//
//  Created by Junky on 2022/9/22.
//

import Foundation






public struct JKSanbox {
    
    public static func getSanBoxVC() -> UIViewController {
        return SanBoxController()
    }
    
    
    public static var log:((_ items: Any) -> Void)? = defoultLog(_:)
    
    static func defoultLog(_ items: Any) {
        print("[JKSanbox]", items)
    }
    
    
}


