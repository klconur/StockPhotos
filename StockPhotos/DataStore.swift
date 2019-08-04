

import Foundation

final class DataStore {
    
    static let sharedInstance = DataStore()
    var apiClient: ApiClient
    var photoData: Welcome?
    
    required init() {
        apiClient = ApiClient()
    }
    
    func fetchInitialPhotos(_ completion: @escaping (Error?) -> Void) {
        apiClient.fetchImages(1, 30) {(_ data, _ error) in
            if (error == nil) {
                self.photoData = data
            }
            completion(error)
        }
    }
    
    func willDisplayItem(_ index: Int) {
        
    }
    
    /* TODO: NOT IMPLEMENTED */
    func fetchPreviousPage(_ completion: @escaping (Error?) -> Void) {
        if let photoData = photoData {
            apiClient.fetchImages(photoData.page - 1, 15) {(_ data, _ error) in
                if (error == nil) {
                    self.photoData = data
                }
                completion(error)
            }
        }
    }
    
    func fetchNextPage(_ completion: @escaping (_ fetchedItemCount: Int, _ error: Error?) -> Void) {
        if let photoData = photoData {
            if (photoData.data.count >= photoData.totalCount) {
                completion(0, nil)
                return
            }
            let itemCount = 15
            let initialPageNumber = photoData.page * photoData.data.count / itemCount
            apiClient.fetchImages(initialPageNumber + 1, itemCount) {(_ data, _ error) in
                if (error == nil) {
                    self.photoData?.data.append(contentsOf: data!.data)
                }
                completion(itemCount, error)
            }
        }
    }
    
    func getPhotoCount() -> Int {
        if let photoData = photoData {
            return photoData.data.count * photoData.page
        }
        return 0
    }
    
    func getPhoto(_ index: Int) -> Thumb? {
        return photoData?.data[index].assets.preview1000
    }
    
}