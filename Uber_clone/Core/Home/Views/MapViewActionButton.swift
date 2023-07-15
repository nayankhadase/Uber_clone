//
//  MapViewActionButton.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import SwiftUI

struct MapViewActionButton: View {
    var body: some View {
        Button(action: {
            //code
        }, label: {
            Image(systemName: "line.3.horizontal")
                .padding()
                .foregroundColor(.primary)
                .font(.system(size: 20))
                .background()
                .clipShape(Circle())
                .shadow(color:.gray,radius: 3)
        })
    }
}

struct MapViewActionButton_Previews: PreviewProvider{
    static var previews: some View{
        MapViewActionButton()
    }
}
