//
import XCTest
import SwiftMagicHelpers
@testable import SwiftPowerStorage

final class SwiftPowerStorage: XCTestCase {
    func testSaveItemDefault() {
        var valueSaved = ""
        let expectations = expectation(description: "Save item default")
        sharedSPSManager.saveParameter(forKey: TestConstants.key, object: TestConstants.value) { (result) in
            switch result {
            case .failure: break
            case .success(value: let value):
                valueSaved = value
                expectations.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertFalse(valueSaved.isEmpty)
            XCTAssertEqual(valueSaved, TestConstants.value)
        }
    }
    
    func testLoadItemDefault() {
        var valueLoaded:String?
        let expectations = expectation(description: "Load item default")
        sharedSPSManager.saveParameter(forKey: TestConstants.key, object: TestConstants.value) { (result) in
            valueLoaded = try? sharedSPSManager.loadParameter(forKey: TestConstants.key, type: type(of: TestConstants.value))
            expectations.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(valueLoaded)
            
            if let valueLoaded = valueLoaded {
                print(valueLoaded)
                XCTAssertFalse(valueLoaded.isEmpty)
                XCTAssertEqual(TestConstants.value, valueLoaded)
            }
        }
    }
    
    func testRemoveParam() {
        var valueRemoved:String?
        var valueNotExist:String?
        let expectations = expectation(description: "Remove item default")
        
        valueRemoved = try? sharedSPSManager.removeParameter(forKey: TestConstants.key, type: type(of: TestConstants.value))
        valueNotExist = try? sharedSPSManager.loadParameter(forKey: TestConstants.key, type: type(of: TestConstants.value))
        expectations.fulfill()
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(valueNotExist)
            XCTAssertNotNil(valueRemoved)
            guard let valueRemoved = valueRemoved else { return }
            XCTAssertFalse(valueRemoved.isEmpty)
            XCTAssertEqual(valueRemoved, TestConstants.value)
        }
    }
    
    func testInvalidTypeWhenLoadItem() {
        var valueLoaded:Any?
        var resultError: SPSError?
        let expectations = expectation(description: "Remove item default")
        sharedSPSManager.saveParameter(forKey: TestConstants.key, object: TestConstants.value) { (result) in    
            switch result {
            case .success(value: _):
                do {
                    valueLoaded = try sharedSPSManager.loadParameter(forKey: TestConstants.key, type: Int.self)
                } catch let error as SPSError {
                    resultError = error
                } catch {
                    print("FAIL")
                }
                expectations.fulfill()
            case .failure: expectations.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(valueLoaded)
            XCTAssertEqual(resultError!.errorType, SPSError.ErrorType.typeError)
        }
    }
}
