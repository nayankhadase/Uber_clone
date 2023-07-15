//
//  HomeView.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showLocationSearch = false
    
    var body: some View {
        ZStack(alignment: .top){
            MapViewRepresentable()
                .ignoresSafeArea()
            
           
            HStack(spacing: 0){
                MapViewActionButton()
                    .padding(.leading)
                LocationSearchActivationView()
                    .onTapGesture {
                        showLocationSearch.toggle()
                    }
            }
            .sheet(isPresented: $showLocationSearch, content: {
                LocationSearchView()
            })
            
        }
    }
}

struct HomeView_Previews: PreviewProvider{
    static var previews: some View{
        HomeView()
    }
}

