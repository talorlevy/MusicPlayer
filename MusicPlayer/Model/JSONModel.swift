//
//  JSONModel.swift
//  MusicPlayer
//
//  Created by Talor Levy on 3/25/23.
//

import Foundation


struct JSONModel: Codable {
    var resultCount: Int?
    var results: [ResultModel]
}
