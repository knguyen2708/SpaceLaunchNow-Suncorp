import Foundation
import UIKit

/// REST Client, used for making HTTP requests.
struct RestClient {
    /// Makes a GET request. Response data is decoded into `Output` using a `JSONDecoder`.
    ///
    /// - Parameters:
    ///     - url: The URL
    ///     - completion: Completion block. Always called on main thread.
    ///
    func get<Output: Decodable>(url: URL, completion: @escaping (Result<Output, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, urlResponse, error in
            // This is called on background thread by URLSession
            // print("RestClient: Is Main Thread: \(Thread.current.isMainThread)")
            
            // Handle error
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                
                return
            }
            
            // Corner cases (probably never happen)
            guard let data = data,
                  let urlResponse = urlResponse as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.unknown))
                }
                
                return
            }
            
            guard (200..<300).contains(urlResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.badStatusCode(urlResponse.statusCode)))
                }
                
                return
            }
            
            // Decode on background thread
            // (Dispatch may not be needed because already on background thread, but that is URLSession implementation)
            // JSON parsing can be slow sometimes
            // Also user already waits for network delay, so a bit more wait for JSON decoding doesn't matter
            
            DispatchQueue.global().async {
                do {
                    let output = try JSONDecoder().decode(Output.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(output))
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        })
        
        task.resume()
    }
    
    /// Makes a GET request and decodes response data into image.
    ///
    /// - Parameters:
    ///     - url: URL of the image
    ///     - completion: Completion block. Always called on main thread.
    func getImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.downloadTask(with: request, completionHandler: { downloadedFileURL, urlResponse, error in
            
            // Handle error
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                
                return
            }
            
            // Corner cases (probably never happen)
            guard let downloadedFileURL = downloadedFileURL,
                  let urlResponse = urlResponse as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.unknown))
                }
                
                return
            }
            
            guard (200..<300).contains(urlResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.badStatusCode(urlResponse.statusCode)))
                }
                
                return
            }
            
            // Move file to temp folder
            // Without this sometimes images fail to load
            
            let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory())
            let tempFileURL = tempDirURL.appendingPathComponent(UUID().uuidString)
            try? FileManager.default.moveItem(at: downloadedFileURL, to: tempFileURL)
            
            // Read data & decompress image on background thread
            // (Dispatch may not be needed because already on background thread, but that is URLSession implementation)
            
            DispatchQueue.global().async {
                guard let image = UIImage(contentsOfFile: tempFileURL.path) else {
                    DispatchQueue.main.async {
                        completion(.failure(CustomError.badImageData))
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            }
        })
        
        task.resume()
    }
    
    /// Errors not emitted by other APIs
    private enum CustomError: LocalizedError {
        case badStatusCode(Int)
        case badImageData
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badStatusCode(let code): return "Bad status code (\(code))"
            case .badImageData: return "Bad image data"
            case .unknown: return "Unknown error"
            }
        }
    }
}
