//
//  AppStoreModel.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/21.
//  Copyright © 2020 am10. All rights reserved.
//

import Foundation

struct AppStoreModel {
    private let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    private var appId: String {
        #if targetEnvironment(macCatalyst)
        return "1494127578"
        #else
        return "1493994947"
        #endif
    }
    private var url: URL {
        return URL(string: "https://itunes.apple.com/lookup?id=\(appId)")!
    }
    var appStoreURL: URL {
        return URL(string: "itms-apps://itunes.apple.com/app/id\(appId)")!
    }

    func checkVersion(completion: @escaping ((Result<AppVersionState, AppVersionError>) -> ())) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.network))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let appVersion = try JSONDecoder().decode(AppVersion.self, from: data)
                if appVersion.version != nil && appVersion.version != self.version && appVersion.version != "1.0" {
                    completion(.success(.shouldUpdate))
                } else {
                    completion(.success(.noUpdate))
                }
                
            } catch {
                completion(.failure(.invalidJSON))
            }
        }
        task.resume()
    }
}

struct AppVersion: Decodable {

    struct Result: Codable {
        let version: String
        let trackName: String
    }

    let name: String?
    let version: String?
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.decodeIfPresent([Result].self, forKey: .results)
        name = results?.first?.trackName
        version = results?.first?.version
    }
}

enum AppVersionError: Error {
    case network
    case invalidData
    case invalidJSON
}

enum AppVersionState {
    case shouldUpdate
    case noUpdate
}
