//
//  NetworkManager.swift
//  Go-JekAssesmentTest
//
//  Created by Manoj Shivhare on 14/05/20.
//  Copyright © 2019 Droom. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class ApiManager: NSObject {
    
    static let shared = ApiManager()
    let session = URLSession(configuration: .default)
    var request : NSMutableURLRequest = NSMutableURLRequest()
    var activityIndicator : UIActivityIndicatorView?
    
    func getUserData(urlStr:String,view:UIView,_ complition: @escaping ([PhotoModel]?)->()) {
        
        guard let url = URL(string: urlStr) else {return}
        request.url = url
        request.httpMethod = "GET"
        request.timeoutInterval = 100
        showProgressView(in: view)
        let task = session.dataTask(with: url) { (data, response, error) in
            self.hideProgressView()
            guard let userData = data, error == nil else  {
                print(error?.localizedDescription ?? "Response error")
                return
            }
            
            let userArr = try? JSONDecoder().decode(PictureModel.self, from: userData).photos?.photo
            complition(userArr)
        }
        task.resume()
    }
    
    //MARK: Show Progress View
    func showProgressView(in view:UIView) {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.frame = view.bounds
        if let progressBar = activityIndicator{
            view.addSubview(progressBar)
        }
        activityIndicator?.startAnimating()
    }
    
    //MARK: Hide Progress View
    func hideProgressView() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
        }
    }
    
}

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
