//
//  MapViewActionButton.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        Button(action: {
            //code
            switch mapState {
            case .noInput:
                print("no input")
                // show menu
            case .locationSelected:
                print("location Selected")
                withAnimation (.easeIn(duration: 1)){
                    DispatchQueue.main.async {
                        mapState = .noInput
                    }
                    locationViewModel.selectedLocation = nil
                }
            case .polylineAdded:
                withAnimation (.easeIn(duration: 1)){
                    DispatchQueue.main.async {
                        mapState = .noInput
                    }
                    
                }
                
            case .searchingForLocation:
                print("searching For Location")
                withAnimation(.easeIn(duration: 1)) {
                    mapState = .noInput
                }
                
            }
        }, label: {
            Image(systemName:getSystemName(for: mapState))
                .padding()
                .foregroundColor(.primary)
                .font(.system(size: 20))
                .background()
                .clipShape(Circle())
                .shadow(color:.gray,radius: 3)
        })
    }
    private func getSystemName(for mapState: MapViewState) -> String{
        switch mapState {
        case .noInput:
            return "line.3.horizontal"
        default:
            return "arrow.backward"
        }
    }
}


struct MapViewActionButton_Previews: PreviewProvider{
    static var previews: some View{
        MapViewActionButton(mapState: .constant(.noInput))
            .environmentObject(LocationSearchViewModel())
    }
}
