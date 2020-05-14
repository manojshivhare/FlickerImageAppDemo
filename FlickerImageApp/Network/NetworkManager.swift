//
//  NetworkManager.swift
//  Go-JekAssesmentTest
//
//  Created by Manoj Shivhare on 14/05/20.
//  Copyright © 2019 Droom. All rights reserved.
//

import Foundation
import UIKit

class ApiManager: NSObject {
    
    static let shared = ApiManager()
    let session = URLSession(configuration: .default)
    var request : NSMutableURLRequest = NSMutableURLRequest()
    var activityIndicator : UIActivityIndicatorView?
    
    func getUserData(urlStr:String,view:UIView,_ complition: @escaping ([PhotoModel])->()) {
        
        guard let url = URL(string: urlStr) else {return}
        request.url = url
        request.httpMethod = "GET"
        request.timeoutInterval = 100
        showProgressView(in: view)
        let task = session.dataTask(with: url) { (data, response, error) in
            self.hideProgressView()
            guard let userData = data, error == nil else  {
                print(error?.localizedDescription ?? "Response error")
                self.showAlertView(alert: "Alert!", message: error!.localizedDescription)
                return
            }
            let userArr = try? JSONDecoder().decode(PictureModel.self, from: userData).photos.photo
            complition(userArr!)
        }
        task.resume()
    }
    
    //MARK: Show Alert View
    func showAlertView(alert: String, message:String) {
        let alert = UIAlertController(title: alert, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
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
