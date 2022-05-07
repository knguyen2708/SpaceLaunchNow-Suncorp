import Foundation
import UIKit

/// An object that gets and caches images in memory.
/// This is not thread-safe and should only be used on main thread.
///
/// - Note: This should only be used with small images.
/// For large images, it is a bad idea to cache in memory.
///
/// TODO:
/// - Disk caching
/// - There may be duplicated requests if user scrolls up and down very quickly
///
class ImageManager {
    static let shared = ImageManager()
    
    let restClient = RestClient()
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    /// Gets image, either by downloading or from cache.
    ///
    /// Completion block is always called on main thread.
    func get(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Locks are not needed because everything happens on main thread
        
        if let image = cache.object(forKey: url as NSURL) {
            completion(.success(image))
            
        } else {
            // DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5..<3)) {
            self.restClient.getImage(url: url, completion: { result in
                switch result {
                case .success(let image):
                    self.cache.setObject(image, forKey: url as NSURL)
                    completion(.success(image))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            })
            // }
        }
    }
    
    /// Whether image for a URL exists in cache
    func isCached(url: URL) -> Bool {
        cache.object(forKey: url as NSURL) != nil
    }
}
