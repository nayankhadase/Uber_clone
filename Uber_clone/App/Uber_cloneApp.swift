//
//  Uber_cloneApp.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import SwiftUI

@main
struct Uber_cloneApp: App {
    @StateObject var viewModel = LocationSearchViewModel()
    
    var body: some Scene {
        
        WindowGroup {
            HomeView()
                .environmentObject(viewModel)
        }
    }
}
