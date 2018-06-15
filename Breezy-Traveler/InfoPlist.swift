//
//  InfoPlist.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 6/9/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

struct InfoPlist {
    subscript(_ key: String) -> Any? {
        if let plist = Bundle.main.infoDictionary {
            return plist[key]
        }
        
        return nil
    }
    
    subscript(string key: String) -> String {
        if let plist = Bundle.main.infoDictionary {
            return plist[key] as! String? ?? ""
        }
        
        return ""
    }
    
    static var baseUrlString: String {
        let plist = InfoPlist()
        
        return plist[string: "Base Url"].replacingOccurrences(of: "\\", with: "")
    }
}
