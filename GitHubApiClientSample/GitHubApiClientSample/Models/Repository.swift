//
//  Repository.swift
//  GitHubApiClientSample
//
//  Created by satoutakeshi on 2020/01/28.
//  Copyright © 2020 satoutakeshi. All rights reserved.
//

import Foundation

struct Repository: Decodable, Hashable, Identifiable {
    var id: Int
    var name: String
    var description: String?
    var stargazersCount: Int = 0
    var language: String?
    var htmlUrl: String
    var owner: Owner
}
