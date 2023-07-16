//
//  RideRequestUIView.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 16/07/23.
//

import SwiftUI

struct RideRequestUIView: View {
    @EnvironmentObject var viewModel: LocationSearchViewModel
    @State private var selectedRideType: RideType = .UberAuto
    
    var body: some View {
        VStack{
//            HStack{
//                Capsule()
//                    .frame(width: 40, height: 4)
//                    .foregroundColor(.secondary.opacity(0.4))
//            }
            ScrollView(.vertical, showsIndicators: false){
                LocationView(viewModel: viewModel, selectedRideType: $selectedRideType)
            }
            .padding(.top)
        }
        .padding(.top, 10)
        .background()
        .frame(height: UIScreen.main.bounds.height * 0.6)
        .animation(.spring())
    }
}

struct RideRequestUIView_Previews: PreviewProvider{
    
    static var previews: some View{
        RideRequestUIView()
            .environmentObject(LocationSearchViewModel())
    }
}

struct LocationView: View {
    @ObservedObject var viewModel: LocationSearchViewModel
    @Binding var selectedRideType: RideType
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                VStack(spacing:3){
                    Circle()
                        .fill(.secondary)
                        .frame(width: 7, height: 6)
                    
                    Rectangle()
                        .frame(width: 0.5, height: 30)
                    
                    Circle()
                        .fill(.primary)
                        .frame(width: 7, height: 6)
                }
                VStack{
                    HStack{
                        Text("Current location")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment:.leading)
        //                    .background(.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        Text(viewModel.pickupTime, style: .time)
                            .foregroundStyle(.secondary)
                    }
                    
                    
                    HStack{
                        Text(viewModel.selectedLocationtext ?? "Destination")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment:.leading)
        //                    .background(.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .fontWeight(.bold)
                        Text(viewModel.dropOffTime, style: .time)
                            .foregroundStyle(.secondary)
                    }
                    
                }
                
                
                
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            
            Text("SUGGESTED RIDE")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(RideType.allCases, id: \.id){ ride in
                        VStack{
                            Image(ride.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                            
                            Text(ride.description)
                            Text(viewModel.calculateRidePrice(forType: ride), format: .currency(code: "INR"))
                        }
                        .padding()
                        .frame(height: 150)
                        .background(selectedRideType == ride ? .blue : .secondary.opacity(0.3))
                        .foregroundStyle(selectedRideType == ride ? .white : .black)
                        .scaleEffect( selectedRideType == ride ? 1.1 : 1)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            withAnimation (.spring()){
                                selectedRideType = ride
                            }
                            
                        }
                    }
                }
            }
            .padding(.leading)
            
            HStack{
                Button(action: {}, label: {
                    HStack{
                        Image(systemName: "creditcard")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                        
                        Text("****4353")
                        
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                })
                .foregroundColor(.primary)
                .padding()
                .background(.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .padding(.horizontal)
            
            Button(action: {}, label: {
                Text("Confirm ride")
                    .foregroundColor(.white)
                    .padding()
            })
            .frame(maxWidth: .infinity)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.horizontal)
            
            Spacer()
        }
        .font(.callout)
    }
}
