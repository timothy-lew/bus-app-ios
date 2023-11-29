//
//  BookmarkBus.swift
//  Bus
//
//  Created by Timothy on 27/11/23.
//

import Foundation
import SwiftData

@Model 
class BookmarkBus {
    @Attribute(.unique) let busStopCode: String
    
    init(busStopCode: String) {
        self.busStopCode = busStopCode
    }
}
