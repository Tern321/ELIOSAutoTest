//
//  ELAutotestModelTests.swift
//  ELIOSAutoTestTests
//
//  Created by EVGENII Loshchenko on 24.02.2023.
//

import XCTest

class LinkedListElement: LLI, Hashable {
    
    var nextElement: LLI?
    var value: AnyObject?
    
    func next() -> LLI? {
        return nextElement
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(String.memoryAddress(obj: self))
    }
    
    static func == (lhs: LinkedListElement, rhs: LinkedListElement) -> Bool {
        return lhs === rhs
    }
}

protocol LLI {
    func next() -> LLI?
}

func listIsCycled(element: LLI?) -> Bool {
    var testElement = element
    
    var set = Set<String>()
    while testElement != nil {
        if !set.contains(String.memoryAddress(obj: testElement as AnyObject)) {
            set.insert(String.memoryAddress(obj: testElement as AnyObject))
        } else {
            return true
        }
        testElement = testElement?.next()
    }
    
    return false
}

class ELAutotestModelTests: XCTestCase {

    func testLinkedListCycle() {
        let element1 = LinkedListElement()
        
        let element2 = LinkedListElement()
        element1.nextElement = element2
        
        let element3 = LinkedListElement()
        element2.nextElement = element3
        
        element3.nextElement = element1
        
        XCTAssertTrue(listIsCycled(element: element1) == true, "error")
    }
    
    func testCustomFunctionTest() {
        XCTAssertTrue(ELAutotestModel.customFunction() == 42, "error")
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
