//
//  NikeCodeSampleTests.swift
//  NikeCodeSampleTests
//
//  Created by Mark Descalzo on 7/21/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import XCTest
@testable import NikeCodeSample

let sampleAlbum: String = """
{
    "artistName": "HARDY",
    "id": "1521977981",
    "releaseDate": "2020-09-04",
    "name": "A ROCK",
    "kind": "album",
    "copyright": "℗ 2020 Big Loud Records",
    "artistId": "1438874739",
    "contentAdvisoryRating": "Explicit",
    "artistUrl": "https://music.apple.com/us/artist/hardy/1438874739?app=music",
    "artworkUrl100": "https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/35/df/bb/35dfbb2b-ba70-7855-c310-8df6807a2d1a/8hUaAF8OT6627CAxOWes_HARDY_AR_v1.jpg/200x200bb.png",
    "genres":
    [
        {
            "genreId": "6",
            "name": "Country",
            "url": "https://itunes.apple.com/us/genre/id6"
        },
        {
            "genreId": "34",
            "name": "Music",
            "url": "https://itunes.apple.com/us/genre/id34"
        }
    ],
    "url": "https://music.apple.com/us/album/a-rock/1521977981?app=music"
}
"""

class NikeCodeSampleTests: XCTestCase {
    
    var testNetworkService: NetworkService?
    var testUrlSession: URLSession?
    var mockAlbumViewModel: AlbumViewModel?
    var mockAlbumModel: AlbumModel?
    var mockBadAlbumModel: AlbumModel?
    
    override func setUpWithError() throws {
        try super .setUpWithError()
        
        testUrlSession = URLSession(configuration: .default)
        testNetworkService = NetworkService()
        
        mockBadAlbumModel = AlbumModel(id: "",
                                    artistName: "HARDY",
                                    releaseDate: "2020-09-04",
                                    name: "A ROCK",
                                    kind: "album",
                                    copyright: "℗ 2020 Big Loud Records",
                                    artistId: "1438874739",
                                    contentAdvisoryRating: "Explicit",
                                    artistUrl: "https://music.apple.com/us/artist/hardy/1438874739?app=music",
                                    artworkUrl100: "https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/35/df/bb/35dfbb2b-ba70-7855-c310-8df6807a2d1a/8hUaAF8OT6627CAxOWes_HARDY_AR_v1.jpg/200x200bb.png",
                                    url: "https://music.apple.com/us/album/a-rock/1521977981?app=music",
                                    genres: [ GenreModel(genreId: "6",
                                                         name: "Country",
                                                         url: "https://itunes.apple.com/us/genre/id6"),
                                              GenreModel(genreId: "34",
                                                         name: "Music",
                                                         url: "https://itunes.apple.com/us/genre/id34") ])

        
        mockAlbumModel = AlbumModel(id: "1521977981",
                                    artistName: "HARDY",
                                    releaseDate: "2020-09-04",
                                    name: "A ROCK",
                                    kind: "album",
                                    copyright: "℗ 2020 Big Loud Records",
                                    artistId: "1438874739",
                                    contentAdvisoryRating: "Explicit",
                                    artistUrl: "https://music.apple.com/us/artist/hardy/1438874739?app=music",
                                    artworkUrl100: "https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/35/df/bb/35dfbb2b-ba70-7855-c310-8df6807a2d1a/8hUaAF8OT6627CAxOWes_HARDY_AR_v1.jpg/200x200bb.png",
                                    url: "https://music.apple.com/us/album/a-rock/1521977981?app=music",
                                    genres: [ GenreModel(genreId: "6",
                                                         name: "Country",
                                                         url: "https://itunes.apple.com/us/genre/id6"),
                                              GenreModel(genreId: "34",
                                                         name: "Music",
                                                         url: "https://itunes.apple.com/us/genre/id34") ])
        if let model = mockAlbumModel {
            mockAlbumViewModel = AlbumViewModel(model: model)
        }
    }

    override func tearDownWithError() throws {
        testUrlSession = nil
        testNetworkService = nil
     
        mockAlbumModel = nil
        mockBadAlbumModel = nil
        mockAlbumViewModel = nil
        
        try super.tearDownWithError()
    }
    
    func testViewModelInit() {
        XCTAssert(mockAlbumViewModel != nil, "Failed to initialize AlbumViewModel.")
    }
    
    func testViewModelInitFail() {
        guard let badModel = mockBadAlbumModel else {
            XCTFail("Unexpected nil test objects!")
            return
        }
        XCTAssert(AlbumViewModel(model: badModel) == nil, "Initialized AlbumViewModel with no id.")
    }
    
    func testViewModelDateFormatter() {
        guard let viewModel = mockAlbumViewModel else {
            XCTFail("Unexpected nil test objects!")
            return
        }
        let testString = viewModel.releaseDateString
        XCTAssert(testString == "September 4, 2020", "Unexpected date string: \(testString)")
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
