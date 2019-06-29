//
//  DHThread+Extension.swift
//  Alamofire
//
//  Created by Emil Karimov on 07/06/2019.
//

import Foundation

public extension Thread {
    
    func doInMainThread(_ codeBlock: @escaping () -> Void) {
        if self.isMainThread {
            codeBlock()
        } else {
            DispatchQueue.main.async {
                codeBlock()
            }
        }
    }
}

