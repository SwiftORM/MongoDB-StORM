//
//  Extensions.swift
//  MongoDBStORM
//
//  Created by Volodymyr Shevchenko on 11/1/17.
//

import Foundation
import PerfectMongoDB

extension BSON.OID
{
    static func isValidObjectId(_ string: String) -> Bool {
        
        #if os(Linux)
            let lengthCondition = string.characters.count == 24
        #else
            let lengthCondition = string.count == 24
        #endif
        guard lengthCondition else {
            return false
        }
        
        let allowed: [Character] = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
        
        #if os(Linux)
            let collection = string.characters
        #else
            let collection = string
        #endif
        
        for character in collection {
            guard allowed.contains(character) else {
                return false
            }
        }
        
        return true
    }
}
