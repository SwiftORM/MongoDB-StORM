import XCTest
import PerfectLib
import StORM
import PerfectMongoDB
import SwiftRandom
@testable import MongoDBStORM



class User: MongoDBStORM {
	// NOTE: First param in class should be the ID.
	var id				: String = ""
	var firstname		: String = ""
	var lastname		: String = ""
	var email			: String = ""
    var pseudonyms      : [String] = [String]()
    var data            : [String: String] = [String: String]()
    
	override init() {
		super.init()
		_collection = "users"
	}

	override func to(_ this: StORMRow) {
		id				= this.data["_id"] as? String ?? ""
		firstname		= this.data["firstname"] as? String ?? ""
		lastname		= this.data["lastname"] as? String ?? ""
		email			= this.data["email"] as? String ?? ""
        pseudonyms      = this.data["pseudonyms"] as? [String] ?? [String]()
        data            = this.data["data"] as? [String: String] ?? [String: String]()
	}

	func rows() -> [User] {
		var rows = [User]()
		for i in 0..<self.results.rows.count {
			let row = User()
			row.to(self.results.rows[i])
			rows.append(row)
		}
		return rows
	}

}


class MongoDBStORMTests: XCTestCase {

	override func setUp() {
		super.setUp()

		MongoDBConnection.host = "localhost"
		MongoDBConnection.database = "perfect_testing"
	}


	/* =============================================================================================
	Save - New
	============================================================================================= */
	func testSaveNew() {
		let obj = User()
		obj.firstname = "No ID Specified"
		obj.lastname = "Y"

		do {
			try obj.save()
		} catch {
			XCTFail("\(error)")
		}
	}
	
	/* =============================================================================================
	Save - New
	============================================================================================= */
	func testSaveNewWithID() {
        
        let first = User()
        first.id = first.newUUID()
        
        let second = User()
        second.id = second.newObjectId()
        
        let objects = [first, second]
        
        for obj in objects {
            obj.firstname = "ID was specified"
            obj.lastname = "Y"
            
            do {
                try obj.save()
            } catch {
                XCTFail("\(error)")
            }
        }
	}

	/* =============================================================================================
	Save - Update
	============================================================================================= */
	func testSaveUpdate() {
        
        let first = User()
        first.id = first.newUUID()
        
        let second = User()
        second.id = second.newObjectId()
        
        let objects = [first, second]
        
        for obj in objects {
            obj.firstname = "X for update"
            obj.lastname = "Y"
            
            do {
                try obj.save()
                print("new id is: \(obj.id)")
            } catch {
                XCTFail("\(error)")
            }
            
            obj.firstname = "A updated"
            obj.lastname = "B"
            do {
                try obj.save()
                print("update, id is: \(obj.id)")
            } catch {
                XCTFail("\(error)")
            }
            print(obj.errorMsg)
            XCTAssert(!obj.id.isEmpty, "Object not saved (update)")
        }
	}

	/* =============================================================================================
	Get (with id)
	============================================================================================= */
	func testGetByPassingID() {
        
        let first = User()
        first.id = first.newUUID()
        
        let second = User()
        second.id = second.newObjectId()
        
        let objects = [first, second]
        
        for obj in objects {
            obj.firstname = "X"
            obj.lastname = "Y"
            
            do {
                try obj.save()
            } catch {
                XCTFail("\(error)")
            }
            
            let obj2 = User()
            
            do {
                try obj2.get(obj.id)
            } catch {
                XCTFail("\(error)")
            }
            XCTAssert(obj.id == obj2.id, "Object not the same (id)")
            XCTAssert(obj.firstname == obj2.firstname, "Object not the same (firstname)")
            XCTAssert(obj.lastname == obj2.lastname, "Object not the same (lastname)")
        }
	}

	/* =============================================================================================
	Get (with id) - no record
	// test get where id does not exist (id)
	============================================================================================= */
	func testGetByPassingIDnoRecord() {
		let obj = User()

		do {
			try obj.get()
			if obj.results.cursorData.totalRecords > 0 {
				XCTFail("Should have returned 0 records (no records)")
			}
		} catch {
			XCTFail("GET error: \(error)")
		}
	}


	// test get where id does not exist ()
	/* =============================================================================================
	Get (preset id) - no record
	// test get where id does not exist (id)
	============================================================================================= */
	func testGetByNonExistingID() {
		let obj = User()
		obj.id = "funkyid"
		do {
			try obj.get()
			if obj.results.cursorData.totalRecords > 0 {
				XCTFail("Should have returned 0 records (no records)")
			}
		} catch {
			XCTFail("GET error: \(error)")
		}
	}



	/* =============================================================================================
	DELETE
	============================================================================================= */
	func testDelete() {
		let obj = User()
		let rand = Randoms.randomAlphaNumericString(length: 12)
		do {
			obj.id			= rand
			obj.firstname	= "Mister"
			obj.lastname	= "PotatoHead"
			obj.email		= "potato@example.com"
			try obj.save()
		} catch {
			XCTFail("\(error)")
		}
		do {
			try obj.delete()
		} catch {
			XCTFail("\(error)")
		}
	}



	/* =============================================================================================
	Find
	============================================================================================= */
	func testFindZero() {
		let obj = User()

		do {
			try obj.find(["firstname":Randoms.randomAlphaNumericString(length: 12)])
			XCTAssert(obj.results.rows.count == 0, "There was at least one row found. There should be ZERO.")
		} catch {
			XCTFail("Find error: \(obj.error.string())")
		}
	}
	func testFind() {
		let obj = User()
		let rand = Randoms.randomAlphaNumericString(length: 12)
		do {
			obj.id	= rand
			obj.firstname	= rand
			obj.lastname	= "PotatoHead"
			obj.email		= "potato@example.com"
			try obj.save()
		} catch {
			XCTFail("\(error)")
		}


		let objFind = User()

		do {
			try objFind.find(["firstname":rand])
			XCTAssert(objFind.results.rows.count == 1, "There should only be one row found.")
		} catch {
			XCTFail("Find error: \(obj.error.string())")
		}
	}

	func testFindAll() {
		let obj = User()

		do {
			try obj.find()
			XCTAssert(obj.results.rows.count > 0, "There were rows found. There should be several.")
		} catch {
			XCTFail("Find error: \(obj.error.string())")
		}
	}


    func testObjectIdValidation() {
        let validObjectIds = [
            "59f891ac0e342a5daf074dc8",
            "123123123123123123123123",
            "aaaaaaaaaaaaaaaaaaaaaaaa",
            "000000000000000000000000"
        ]
        
        for validObjectId in validObjectIds {
            XCTAssertTrue(BSON.OID.isValidObjectId(validObjectId) == true, "")
        }
        
        let invalidObjectIds = [
            "59f891ac0e342a5daf074dc859f891ac0e342a5daf074dc8",
            "59f891ac0e342a5daf074dc",
            "59r891rr0e342a5daf074dc8",
            "59f891ac0e342a5daf074dc8".uppercased(),
            "Abracadabra",
            "1234546",
            ""
        ]
        
        for invalidObjectId in invalidObjectIds {
            XCTAssertTrue(BSON.OID.isValidObjectId(invalidObjectId) == false, "")
        }
    }


    func testArrayData() {
        let obj = User()
        
        let pseudonyms = ["Santa", "SantaClaus", "SC", "Potato", "Not Potato", "What else?"]
        let id = obj.newObjectId()
        
        obj.id = id
        obj.pseudonyms = pseudonyms
        do {
            try obj.save()
        } catch {
            XCTFail("Save error: \(obj.error.string())")
        }
        
        let fetched = User()
        fetched.id = id
        do {
            try fetched.get()
        } catch {
            XCTFail("Find error: \(obj.error.string())")
        }
        
        XCTAssertTrue(fetched.pseudonyms == pseudonyms, "Fetched data is not equal to saved")
    }

    func testDictionaryData()
    {
        let obj = User()
        
        let data = [            
            "Foo": "Bar",
            "True": "False",
            "Yellow": "Potato"
        ]
        let id = obj.newObjectId()
        
        obj.id = id
        obj.data = data
        do {
            try obj.save()
        } catch {
            XCTFail("Save error: \(obj.error.string())")
        }
        
        let fetched = User()
        fetched.id = id
        do {
            try fetched.get()
        } catch {
            XCTFail("Find error: \(obj.error.string())")
        }
        
        XCTAssertTrue(fetched.data == data, "Fetched data is not equal to saved")
    }
    
	static var allTests : [(String, (MongoDBStORMTests) -> () throws -> Void)] {
		return [
			("testSaveNew", testSaveNew),
			("testSaveNewWithID", testSaveNewWithID),
			("testSaveUpdate", testSaveUpdate),
			("testGetByPassingID", testGetByPassingID),
			("testGetByPassingIDnoRecord", testGetByPassingIDnoRecord),
			("testGetByNonExistingID", testGetByNonExistingID),
			("testDelete", testDelete),
			("testFind", testFindZero),
			("testFind", testFind),
			("testFindAll", testFindAll),
            ("testObjectIdValidation", testObjectIdValidation)
		]
	}

}


