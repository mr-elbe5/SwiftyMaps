//
//  String.swift
//
//  Created by Michael Rönnau on 18.05.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func localize() -> String{
        return NSLocalizedString(self,comment: "")
    }
    
    func localize(i: Int) -> String{
        return String(format: NSLocalizedString(self,comment: ""), String(i))
    }
    
    func localize(s: String) -> String{
        return String(format: NSLocalizedString(self,comment: ""), s)
    }
    
    func trim() -> String{
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func removeTimeStringMilliseconds() -> String{
        if self.hasSuffix("Z"), let idx = self.lastIndex(of: "."){
            return self[self.startIndex ..< idx] + "Z"
        }
        return self
    }
    
    func ISO8601Date() -> Date?{
        ISO8601DateFormatter().date(from: self.removeTimeStringMilliseconds())
    }

}
