//
//  HomeView.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showLocationSearch = false
    @State private var mapViewState: MapViewState = .noInput
    
    var body: some View {
        ZStack(alignment: .bottom){
            ZStack(alignment: .top){
                MapViewRepresentable(mapState: $mapViewState)
                    .ignoresSafeArea()
                
                VStack{
                    HStack(spacing: 0){
                        MapViewActionButton(mapState: $mapViewState)
                            .padding(.leading)
                        Spacer()
                        if mapViewState == .noInput{
                            LocationSearchActivationView()
                                .onTapGesture {
                                    showLocationSearch.toggle()
                                }
                        }
                    }
                    
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            if mapViewState == .locationSelected{
                RideRequestUIView()
                    .transition(.move(edge: .bottom))
                
                    .cornerRadius(40, corners: [.topLeft, .topRight])
                
                    .shadow(radius: 5, y:-5)
                
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showLocationSearch, content: {
            LocationSearchView(mapState: $mapViewState)
        })
        
        
    }
}

struct HomeView_Previews: PreviewProvider{
    static var previews: some View{
        HomeView()
            .environmentObject(LocationSearchViewModel())
    }
}

