//
//  AppRouter.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//

import Foundation

@Observable
class AppRouter {
    var selectedTab: Tab = .run
    var selectedRun: RunDetails? = nil
    
    enum Tab: Int {
        case run = 0
        case activity = 1
    }
}
