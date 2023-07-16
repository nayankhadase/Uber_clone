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
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        ZStack(alignment: .bottom){
            ZStack(alignment: .top){
                MapViewRepresentable(mapState: $mapViewState)
                    .ignoresSafeArea()
                
                VStack{
                    HStack(spacing: 0){
                        MapViewActionButton(mapState: $mapViewState)
                            .padding(.leading, 8)
                        Spacer()
                        if mapViewState == .noInput{
                            LocationSearchActivationView()
                                .padding(.trailing)
                                .onTapGesture {
                                    showLocationSearch.toggle()
                                }
                        }
                    }
                    
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            if mapViewState == .locationSelected || mapViewState == .polylineAdded{
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
        .onReceive(LocationManager.shared.$userLocation, perform: { location in
            locationViewModel.userLocation = location
        })
        
        
    }
}

struct HomeView_Previews: PreviewProvider{
    static var previews: some View{
        HomeView()
            .environmentObject(LocationSearchViewModel())
    }
}

