import XCTest
import LevelDB

class LevelDBTest: XCTestCase {
    var subject: LevelDB!
    let dbURL = NSURL(fileURLWithPath: "/tmp/testDB")

    override func setUp() {
        subject = LevelDB(DBURL: dbURL)
    }

    override func tearDown() {
        if subject != nil { subject.closeDB() }
        LevelDB.destroyDBWithDBURL(dbURL, error: nil)
    }

    func testPut() {
        var error: NSError?
        let result = subject.putKey("foo", value: "bar", error: &error)

        XCTAssert(result, "Unable to put key")
        XCTAssert(error == nil, "Error should be nil: \(error)")
    }

    func testGet() {
        var error: NSError?
        subject.putKey("foo", value: "bar", error: nil)
        let result = subject.getKey("foo", error: &error)

        XCTAssert(result == "bar", "Returned incorrect value")
        XCTAssert(error == nil, "Error should be nil: \(error)")
    }

    func testDelete() {
        var error: NSError?
        subject.putKey("foo", value: "bar", error: nil)
        let result = subject.deleteKey("foo", error: &error)

        XCTAssert(result, "Unable to delete key")
        XCTAssert(error == nil, "Error should be nil: \(error)")
    }

    func testWriteBatch() {
        var error = subject.writeBatch { writeBatch in
            writeBatch.putKey("foo", value: "bar")
            writeBatch.putKey("bar", value: "baz")
            writeBatch.deleteKey("foo")
        }
        XCTAssert(error == nil, "Error should be nil: \(error)")

        let result = subject.getKey("bar", error: &error)
        XCTAssert(error == nil, "Error should be nil: \(error)")
        XCTAssert(result == "baz", "Invalid value")
    }

    func testGenerator() {
        for idx in 0...10 {
            subject.putKey("foo\(idx)", value: "bar", error: nil)
        }

        var correctCount = 0
        /**
         * for (key, value) in subject {}
         * Doesn't work, cases swift frontend to crash
         **/
        var generator = subject.generate()
        while let (key, value) = generator.next() {
            if (value == "bar") { correctCount++ }
        }

        XCTAssert(correctCount == 10, "Should return bar 10 times")
    }

    func testEnumeratorTillPrefix() {
        for idx in 0...10 {
            subject.putKey("foo\(idx)", value: "bar", error: nil)
        }

        let enumerator = subject.enumeratorWithOptions(defaultReadOptions)
        enumerator.seekTillPrefix("foo5");
        let values = enumerator.allValuesUntilPrefix("foo8")

        let keys = values.map { (key, value) in key }
        XCTAssert(keys == ["foo5", "foo6", "foo7"], "Invalid enum keys")
    }

    func testEnumeratorAllWithPrefix() {
        subject.putKey("foo1", value: "bar", error: nil)
        subject.putKey("bar1", value: "bar", error: nil)
        subject.putKey("foo2", value: "bar", error: nil)
        subject.putKey("bar2", value: "bar", error: nil)

        let enumerator = subject.enumeratorWithOptions(defaultReadOptions)
        let values = enumerator.allValuesWithPrefix("foo")

        let keys = values.map { (key, value) in key }
        XCTAssert(keys == ["foo1", "foo2"], "Invalid enum keys")
    }
}
