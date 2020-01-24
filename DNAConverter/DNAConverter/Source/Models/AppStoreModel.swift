//
//  AppStoreModel.swift
//  DNAConverter
//
//  Created by am10 on 2020/01/21.
//  Copyright © 2020 am10. All rights reserved.
//

import Foundation

struct AppStoreModel {
    private let version = Version(version: Bundle.main.version!)
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
                if let version = appVersion.version,
                    Version(version: version) > self.version {
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

struct Version {
    let major: Int
    let minor: Int
    let revision: Int
}

extension Version {
    init(version: String) {
        let versions = version.components(separatedBy: ".")
        self.major = versions[safe: 0].flatMap { Int($0) } ?? 0
        self.minor = versions[safe: 1].flatMap { Int($0) } ?? 0
        self.revision = versions[safe: 2].flatMap { Int($0) } ?? 0
    }

    static func > (lhs: Version, rhs: Version) -> Bool {
        if lhs.major > rhs.major {
            return true
        }
        if lhs.major < rhs.major {
            return false
        }
        // lhs.major == rhs.major
        if lhs.minor > rhs.minor {
            return true
        }
        if lhs.minor < rhs.minor {
            return false
        }
        // lhs.major == rhs.major && lhs.minor == rhs.minor
        if lhs.revision > rhs.revision {
            return true
        }
        return false
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
