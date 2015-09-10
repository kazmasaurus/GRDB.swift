import XCTest
import GRDB

class DictionaryRowTests: GRDBTestCase {
    
    func testRowAsSequence() {
        let row = Row(dictionary: ["a": 0, "b": 1, "c": 2])
        
        var columnNames = Set<String>()
        var ints = Set<Int>()
        var bools = Set<Bool>()
        for (columnName, databaseValue) in row {
            columnNames.insert(columnName)
            ints.insert(databaseValue.value()! as Int)
            bools.insert(databaseValue.value()! as Bool)
        }
        
        XCTAssertEqual(columnNames, ["a", "b", "c"])
        XCTAssertEqual(ints, [0, 1, 2])
        XCTAssertEqual(bools, [false, true, true])
    }
    
    func testRowValueAtIndex() {
        // Expect fatal error:
        //
        // let row = Row(dictionary: ["a": 0, "b": 1, "c": 2])
        // row.value(atIndex: -1)
        // row.value(atIndex: 3)
    }
    
    func testRowValueNamed() {
        let row = Row(dictionary: ["a": 0, "b": 1, "c": 2])
        
        XCTAssertEqual(row.value(named: "a")! as Int, 0)
        XCTAssertEqual(row.value(named: "b")! as Int, 1)
        XCTAssertEqual(row.value(named: "c")! as Int, 2)
        
        XCTAssertEqual(row.value(named: "a")! as Bool, false)
        XCTAssertEqual(row.value(named: "b")! as Bool, true)
        XCTAssertEqual(row.value(named: "c")! as Bool, true)
        
        // Expect fatal error:
        // row.value(named: "foo")
        // row.value(named: "foo") as Int?
    }
    
    func testRowCount() {
        let row = Row(dictionary: ["a": 0, "b": 1, "c": 2])
        XCTAssertEqual(row.count, 3)
    }
    
    func testRowColumnNames() {
        let row = Row(dictionary: ["a": 0, "b": 1, "c": 2])
        XCTAssertEqual(Array(row.columnNames).sort(), ["a", "b", "c"])
    }
    
    func testRowDatabaseValues() {
        let row = Row(dictionary: ["a": 0, "b": 1, "c": 2])
        XCTAssertEqual(row.databaseValues.sort { ($0.value() as Int!) < ($1.value() as Int!) }, [0.databaseValue, 1.databaseValue, 2.databaseValue])
    }
    
    func testRowSubscriptIsCaseInsensitive() {
        let row = Row(dictionary: ["name": "foo"])
        XCTAssertEqual(row["name"], "foo".databaseValue)
        XCTAssertEqual(row["NAME"], "foo".databaseValue)
        XCTAssertEqual(row["NaMe"], "foo".databaseValue)
        XCTAssertEqual(row.value(named: "name")! as String, "foo")
        XCTAssertEqual(row.value(named: "NAME")! as String, "foo")
        XCTAssertEqual(row.value(named: "NaMe")! as String, "foo")
    }
}