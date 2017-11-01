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
        let regEx = "[0-9a-f]{24}"
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: string)
    }
}
