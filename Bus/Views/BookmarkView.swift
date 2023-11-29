//
//  Bookmark.swift
//  Bus
//
//  Created by Timothy on 26/11/23.
//

import SwiftData
import SwiftUI

struct BookmarkView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Query(sort: \BookmarkBus.busStopCode, order: .forward, animation: .smooth) var bookmarkCodes: [BookmarkBus]
    
    var body: some View {
        List {
            ForEach(bookmarkCodes, id: \.busStopCode) { bookmarkCode in
                NavigationLink {
                    BusView(busStopCode: bookmarkCode.busStopCode)
                } label : {
                    BusStopView(busStopCode: bookmarkCode.busStopCode)
                }
            }
        }
        .padding(.bottom, 20) // dont overlap with tab
    }
    
}

#Preview {
    BookmarkView()
}
