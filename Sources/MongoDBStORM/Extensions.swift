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
        
        if let expression = try? NSRegularExpression(pattern: "[0-9a-f]{24}", options: []) {
            #if os(Linux)
                let range = NSMakeRange(0, string.characters.count)
            #else
                let range = NSMakeRange(0, string.count)
            #endif
            return expression.numberOfMatches(in: string, options: [], range: range) == 1
        }
        return false
    }
}
