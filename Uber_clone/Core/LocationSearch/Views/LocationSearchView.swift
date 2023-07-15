//
//  LocationSearchView.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import SwiftUI
import MapKit

struct LocationSearchView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    
    var body: some View {
        VStack(spacing:0){
            //
            HStack{
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundStyle(.white)
                })
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(.green)
            
            Divider()
                .padding(.bottom)
            
            // header view
            HeaderView(currentLocation: $viewModel.currentLocation, destinationLocation: $viewModel.queryFragment)
                .padding([.horizontal, .bottom])
            
            Divider()
                .padding([.horizontal, .bottom])
                
            //ListView
            ScrollView{
                VStack{
                    ForEach(viewModel.results, id: \.self){ result in
                        
                        LocationDetailsView(searchResult: result)
                            .padding(.horizontal)
                            .onTapGesture {
                                viewModel.selectLocation(result)
                                dismiss()
                            }
                    }
                }
            }
            
            
            
            Spacer()
        }
    }
}

struct HeaderView: View {
    @Binding var currentLocation: String
    @Binding var destinationLocation: String
    
    var body: some View {
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
                TextField("Current location", text: $currentLocation)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                
                TextField("Destination location", text: $destinationLocation)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider{
    static var previews: some View{
        LocationSearchView()
    }
}

struct LocationDetailsView: View {
    let searchResult: MKLocalSearchCompletion
    
    var body: some View {
        HStack{
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 30))
                .foregroundStyle(.green)
            
            VStack(alignment: .leading, spacing:0){
                
                Text(searchResult.title)
                    .frame(maxWidth: .infinity,alignment:.leading)
                    .font(.body)
                
                Text(searchResult.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .padding(.top, 10)
            }
            
            
        }
        .padding(.bottom, 5)
    }
}
