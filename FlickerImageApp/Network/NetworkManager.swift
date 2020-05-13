//
//  NetworkManager.swift
//  Go-JekAssesmentTest
//
//  Created by Manoj Shivhare on 20/07/19.
//  Copyright © 2019 Droom. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    
    mutating func appendString(str:String) {
        if let data = str.data(using: .utf8, allowLossyConversion: true) {
            append(data)
        }
    }
}

struct API {
     static let baseURL = "https://api.flickr.com/services/rest/?method=flickr.galleries.getPhotos&api_key=d8158e574d6b7daadd8032dd7e00db4c&gallery_id=66911286-72157647277042064&format=json&nojsoncallback=1"
}

struct ImageAPI {
    static let clientID = "e623da2721c6b89f"
}

class ApiManager: NSObject {
   
    static let shared = ApiManager()
    let session = URLSession(configuration: .default)
    var request : NSMutableURLRequest = NSMutableURLRequest()
    
    func getUserData(_ complition: @escaping (PictureModel?)->()) {
        
        guard let url = URL(string: API.baseURL) else {return}
        request.url = url
        request.httpMethod = "GET"
        request.timeoutInterval = 100
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let userData = data, error == nil else  {
                print(error?.localizedDescription ?? "Response error")
                return
            }
            let userDic = try? JSONDecoder().decode(PictureModel.self, from: userData)
            complition(userDic)
        }
        task.resume()
    }
    
}

class NetworkManager {
    static let shared = NetworkManager(baseURL: URL(string:API.baseURL)!)

    let baseURL : URL

    var activityIndicator : UIActivityIndicatorView?

    typealias JSONDictionary = [String : Any]
    typealias JSONArray = [Any]

    typealias SuccessHandlerForGet = (_ json : JSONArray) -> ()
    typealias SuccessHandlerForPost = (_ json : JSONDictionary) -> ()
    typealias ImageSuccessHandler = (_ image : UIImage) -> ()
    typealias ErrorHandler = (_ error : Error) -> ()

    lazy var defaultSession:URLSession = {

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type":"application/json; charset=UTF-8"]
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)

    }()

    private init(baseURL:URL){
        self.baseURL = baseURL
    }

    //MARK: GET request method
    func getRequest(view:UIView,
                    success: @escaping (SuccessHandlerForGet),
                    failure: @escaping (ErrorHandler)) {

        showProgressView(in: view)

//        let url = self.baseURL.appendingPathComponent(urlString)

        let urlRequest = URLRequest(url: self.baseURL)

        let task = defaultSession.dataTask(with: urlRequest, completionHandler: { (data,response,error) -> () in

            self.hideProgressView()

            guard error == nil else {
                failure(error!)
                return
            }

            if let aData = data,
                let urlResponse = response as? HTTPURLResponse,
                (200..<300).contains(urlResponse.statusCode) {

                do {
                  let responseJSON  = try JSONDecoder().decode([PictureModel].self, from: aData)
                    DispatchQueue.main.async {
                        success(responseJSON)
                    }
                }
                catch let error as NSError {
                    failure(error)
                }
            }
        })
        task.resume()

    }

    //MARK: POST method
    func postRequest(urlString: String,
                     params:[String : Any],
                     view:UIView,
                     requestType:String,
                     success:@escaping (SuccessHandlerForPost),
                     failure:@escaping (ErrorHandler)) {

        showProgressView(in: view)

        let url = self.baseURL.appendingPathComponent(urlString)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.networkServiceType = .default
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
        urlRequest.timeoutInterval = 100
        urlRequest.httpShouldHandleCookies = true
        urlRequest.httpShouldUsePipelining = false
        urlRequest.allowsCellularAccess = true

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }

        let task = defaultSession.dataTask(with: urlRequest, completionHandler: {(data, response, error) -> () in

            self.hideProgressView()

            guard error == nil else {
                failure(error!)
                return
            }

            if let aData = data,
                let urlResponse = response as? HTTPURLResponse,
                (200..<300).contains(urlResponse.statusCode) {

                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: aData, options: [])
                    DispatchQueue.main.async {
                        success(responseJSON as! NetworkManager.JSONDictionary)
                    }
                }
                catch let error as NSError {
                    failure(error)
                }
            }

        })

        task.resume()
    }

    //MARK: Show Alert View
    func showAlertView(alert: String, message:String) {
        let alert = UIAlertController(title: alert, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
    }

    //MARK: Download image from server
    func downloadImageFile(urlString:String,
                           view:UIView,
                           success:@escaping (ImageSuccessHandler),
                           failure:@escaping (ErrorHandler) ) {

        let url = URL(string: urlString)

        guard let unwrappedURL = url else {
            return
        }

        let task = defaultSession.downloadTask(with: unwrappedURL, completionHandler: {(localURL, response, error) in

            guard error == nil else {
                failure(error!)
                return
            }

            if let fileURL = localURL {

                do {
                    let imageData = try Data(contentsOf: fileURL)
                    if let image = UIImage(data: imageData) {
                        success(image)
                    }

                }
                catch let error as NSError {
                    failure(error)
                }
            }

        })

        task.resume()
    }

    func showProgressView(in view:UIView) {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.frame = view.bounds
        if let progressBar = activityIndicator{
            view.addSubview(progressBar)
        }
        activityIndicator?.startAnimating()
    }

    func hideProgressView() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
        }
    }

}
