//
//  MapViewRepresentable.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import SwiftUI
import MapKit


struct MapViewRepresentable: UIViewRepresentable{
    
    let mapView = MKMapView()
    let locationManager = LocationManager()
    
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        
        mapView.delegate = context.coordinator // set delegate
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //code
        if let selectedLocation = viewModel.selectedLocation{
            print("selected location: \(selectedLocation)")
            
            // add annotation
            context.coordinator.addAndSelectAbbotation(withCoordinate: selectedLocation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    //MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate{
        let parent: MapViewRepresentable
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let coordinate = userLocation.coordinate
            // create region center around specific coordinate
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                self.parent.mapView.setRegion(region, animated: true) // update region for map view
        }
        
        //MARK: - helper
        
        func addAndSelectAbbotation(withCoordinate coordinate: CLLocationCoordinate2D){
            // remove previous anotation:
            self.parent.mapView.removeAnnotations(self.parent.mapView.annotations)
            
            // create annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            // set annotation
            self.parent.mapView.addAnnotation(annotation)
            // select annotation so it looks big pin on map
            self.parent.mapView.selectAnnotation(annotation, animated: true)
            
            // show all anotation in visible space(change map view region)
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        
        
        
    }
    
    
    // end
}
