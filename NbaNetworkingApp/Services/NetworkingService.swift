//
//  NetworkingService.swift
//  NbaNetworkingApp
//
//  Created by Флоранс on 16.02.2024.
//

import Foundation
import Alamofire

enum Link: String {
    case allSourcesURL = "https://newsapi.org/v2/top-headlines/sources?apiKey=f7f06deb190845969c90760356d28f92"
    case newsBySourceURL = "https://newsapi.org/v2/top-headlines?sources="//bbc-news&apiKey=f7f06deb190845969c90760356d28f92"
    
    case apiKey = "f7f06deb190845969c90760356d28f92"
}

enum NetworkError: Error {
    case decodingError
    case noData
    
}

class NetworkingService {
    static let shared =  NetworkingService()
    private init() {}
    
    func fetchData<T>(_ type: T.Type, from url: String, completion: @escaping(Result<[T], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    if let type = type as? Source.Type {
                        let sources = type.getSources(from: value)
                        completion(.success((sources as? [T])!))
                    } else if let type = type as? Article.Type {
                        //print(value)
                        let articles = type.getArticles(from: value)
                        completion(.success((articles as? [T])!))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { dataResponse in
                switch dataResponse.result {
                case .success(let imageData):
                    completion(.success(imageData))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
//    func fetch<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping(Result<T, NetworkError>) -> Void) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                completion(.failure(.noData))
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//            
//            //print(response)
//            
//            let decoder = JSONDecoder()
//            
//            do {
//                let dataModel = try decoder.decode(T.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(dataModel))
//                }
//            } catch let error1 {
//                print(error1)
//                completion(.failure(.decodingError))
//            }
//
//        }.resume()
//    }
//    
//    func fetchImage(from url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
//        guard let url = URL(string: url) else { return }
//                
//        DispatchQueue.global().async {
//            guard let imageData = try? Data(contentsOf: url) else {
//                completion(.failure(.noData))
//                return
//            }
//            DispatchQueue.main.async {
//                completion(.success(imageData))
//            }
//        }
//    }
    
}
