//
//  LocationSearchActivationView.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        HStack(spacing:0){
            Circle()
                .fill()
                .frame(width: 10)
                .padding()
            
            Text("Where to?")
            
            Spacer()
            
        }
        
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color:.gray, radius: 3)
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider{
    static var previews: some View{
        LocationSearchActivationView()
    }
}
