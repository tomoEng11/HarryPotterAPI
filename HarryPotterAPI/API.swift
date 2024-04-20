//
//  API.swift
//  HarryPotterAPI
//
//  Created by 井本智博 on 2024/04/16.
//

import Foundation

enum HPError: Error {
case invalidURL, network, decoding, unableToComlete
}

class API {

    static let shared = API()
    private init() {}

    let endpoint = "https://hp-api.onrender.com/api/characters"

    func getData() async -> [HPModel] {

        guard let url = URL(string: endpoint) else {
            return []
        }
        do {
            let (hpData, _) = try await URLSession.shared.data(from: url)
            let hp = try JSONDecoder().decode([HPModel].self, from: hpData)
            return hp
        } catch {
            return []
        }
    }

//    func getData(completion: @escaping (Result<[HPModel], HPError>) -> Void) {
//        guard let url = URL(string: endpoint) else {
//            completion(.failure(HPError.invalidURL))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard error == nil, let safeData = data else {
//                completion(.failure(HPError.network))
//                return
//            }
//            do {
//                let decodedData = try JSONDecoder().decode([HPModel].self, from: safeData)
//                completion(.success(decodedData))
//            } catch {
//                completion(.failure(HPError.decoding))
//            }
//        }
//        task.resume()
//    }
}


struct HPModel: Codable, Hashable {
    let name: String
    let id: String
    let house: String
}


public func DLog(_ obj: Any? = nil, file: String = #file, function: String = #function, line: Int = #line) {
    var filename: NSString = file as NSString
    filename = filename.lastPathComponent as NSString
    let text: String
    if let obj = obj {
        text = "[File:\(filename) Func:\(function) Line:\(line)] : \(obj)"
    } else {
        text = "[File:\(filename) Func:\(function) Line:\(line)]"
    }
    print(text)
}
