//
//  parseRows.swift
//  PostgresStORM
//
//  Created by Jonathan Guthrie on 2016-10-06.
//
//

import StORM
import PerfectMongoDB
import PerfectLib
import Foundation

/// Supplies the parseRows method extending the main CouchDBStORM class.
extension MongoDBStORM {

	/// parseRows takes the [String:Any] result and returns an array of StormRows 
	public func parseRows(_ result: MongoCursor) throws -> [StORMRow] {

		var resultRows = [StORMRow]()

		for i in result {
			let thisRow = StORMRow()
			let ii = try? i.asString.jsonDecode()
			thisRow.data = ii as! Dictionary<String, Any>
			resultRows.append(thisRow)
		}
		
		return resultRows
	}
}
