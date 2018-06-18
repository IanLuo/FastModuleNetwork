import XCTest
import FastModule
@testable import FastModuleNetwork

final class FastModuleNetworkTests: XCTestCase {
    func testCancel() throws {
        DynamicModule.register()
        
        let ex = self.expectation(description: "")
        let request = Request(requestPattern: "data/get/#url1(http://www.baidu.com)")
        let test = FastModuleHTTP.instance(name: "http", pattern: "")
        test.executor(request: request).run {
            switch $0 {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error {
                case ExecutionError.canceled:
                    ex.fulfill()
                default:
                    XCTAssert(false)
                }
            }
        }
        test.dispose(request: request)
        
        self.wait(for: [ex], timeout: 10)
    }
    
    func testRequestData() throws {
        DynamicModule.register()
        
        let ex = self.expectation(description: "")
        var request = Request(requestPattern: "data/get/#url1(http://www.baidu.com)")
        request["parameters"] = [:]
        request["headers"] = [:]
        let test = FastModuleHTTP.instance(name: "http", pattern: "")
        test.executor(request: request).run {
            switch $0 {
            case .success(let value):
                XCTAssertTrue(value is Data)
                ex.fulfill()
            case .failure(_):
                XCTAssert(false)
            }
        }
        
        self.wait(for: [ex], timeout: 10)
    }
    
    func testRequestText() throws {
        DynamicModule.register()
        
        let ex = self.expectation(description: "")
        let request = Request(requestPattern: "text/get/#url1(http://www.baidu.com)")
        let test = FastModuleHTTP.instance(name: "http", pattern: "")
        test.executor(request: request).run {
            switch $0 {
            case .success(let value):
                XCTAssertTrue(value is String)
                ex.fulfill()
            case .failure(_):
                XCTAssert(false)
            }
        }
        
        self.wait(for: [ex], timeout: 10)
    }
}
