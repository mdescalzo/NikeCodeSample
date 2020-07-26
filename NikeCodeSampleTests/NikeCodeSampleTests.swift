//
//  NikeCodeSampleTests.swift
//  NikeCodeSampleTests
//
//  Created by Mark Descalzo on 7/21/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import XCTest
@testable import NikeCodeSample

class NikeCodeSampleTests: XCTestCase {
    
    var testNetworkService: NetworkService?
    var testUrlSession: URLSession?

    override func setUpWithError() throws {
        try super .setUpWithError()
        
        testUrlSession = URLSession(configuration: .default)
        testNetworkService = NetworkService()
    }

    override func tearDownWithError() throws {
        testUrlSession = nil
        testNetworkService = nil
        
        try super.tearDownWithError()
    }
 
    func testCallToEndPointCompletes() {
        guard let sessionUt = testUrlSession,
            let serviceUt = testNetworkService else {
            XCTFail("Unexpected nil test objects!")
            return
        }
        
        guard let url = URL(string: serviceUt.endpoint) else {
            XCTFail("Invalid URL in \(#function)")
            return
        }
        let promise = expectation(description: "Url session completion handler invoked.")
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = sessionUt.dataTask(with: url) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 10)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}
