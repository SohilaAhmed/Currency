//
//  ApiClient.swift
//  Currency
//
//  Created by Sohila on 01/06/2023.
//

import Foundation

private let BASE_URL = "https://api.apilayer.com/exchangerates_data/"

protocol Service{
    static func getApi<T: Decodable>(endPoint: EndPoints, completionHandeler: @escaping ((T?), Error?) -> Void)
}

class NetworkService : Service{
     
    static func getApi<T: Decodable>(endPoint: EndPoints, completionHandeler: @escaping ((T?), Error?) -> Void){
        
        let path = "\(BASE_URL)\(endPoint.path)"
        let url = URL(string: path)
        guard let url = url else{ return }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.addValue("qWlUq8mN5mvsCER1ypEe63ldkLL5PfBa", forHTTPHeaderField: "apikey")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: req) { data, response, error in
            if let error = error{
                print(error.localizedDescription)
                completionHandeler(nil, error)
            }else{
                guard let data = data else {
                    print(String(describing: error))
                    return
                  }
                let res = try? JSONDecoder().decode(T.self, from: data)
                print(String(data: data, encoding: .utf8)!)
                completionHandeler(res, nil)
            }
            
        }
        task.resume()
    }
    

}

