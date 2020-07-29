//
//  NetworkService.swift
//

import UIKit


enum NetworkError : Error {
    case invalidURL
    case emptyData
}

/**
 Model for root of fetched resutls
 */
struct ServiceResponse: Codable {
    let feed: FeedModel
}

/**
 Model for the main blob of the fetched results
 */
struct FeedModel: Codable {
    let title: String
    let id: String
    let copyright: String
    let updated: String
    let results: [AlbumModel]?
}

/**
 Model for fetched results
 */
struct FetchResult {
    let results: [AlbumModel]?
    let error: Error?
}

class NetworkService {
    
    /**
     Endpoint
     */
    internal let endpoint: String = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
    
    fileprivate var task: URLSessionTask?
    
    /**
     Initiate retrieval of album records
     
     - Parameter completion: Closure ( (FetchResult) -> Void )
     */
    func fetchRecords(completion: @escaping (FetchResult) -> Void) {
        
        func errorCompletion(_ error: Error) {
            completion(FetchResult(results: nil, error: error))
        }
        
        guard let url = URL(string: endpoint) else {
            errorCompletion(NetworkError.invalidURL)
            return
        }
        
        task?.cancel()
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                guard (error as NSError).code != NSURLErrorCancelled else {
                    return
                }
                errorCompletion(error)
                return
            }
            guard let data = data else {
                errorCompletion(NetworkError.emptyData)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ServiceResponse.self, from: data)
                if result.feed.results != nil {
                    print("Number of results: \(result.feed.results!.count)")
                }
                completion(FetchResult(results: result.feed.results, error: nil))
            } catch {
                errorCompletion(error)
            }
        }
        task?.resume()
    }
    
    /**
     Cancel a pending fetch task
     */
    func cancelFetch() {
        if let task = task {
            task.cancel()
        }
    }
    
}

