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
            context.coordinator.configurePloyline(withdestination: selectedLocation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    //MARK: - Coordinator, MKMapViewDelegate
    
    class Coordinator: NSObject, MKMapViewDelegate{
        let parent: MapViewRepresentable
        var userLocation: CLLocationCoordinate2D?
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let coordinate = userLocation.coordinate
            self.userLocation = coordinate
            
            // create region center around specific coordinate
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                self.parent.mapView.setRegion(region, animated: true) // update region for map view
        }
        
        //(delegate method which tels map to draw overlay) use to draw a overlay on the map
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .systemBlue
            render.lineWidth = 6
            return render
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
        
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (MKRoute) -> Void){
            let userplacemark = MKPlacemark(coordinate: userLocation)
            let destiPlacemark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userplacemark)
            request.destination = MKMapItem(placemark: destiPlacemark)
            
            let direction = MKDirections(request: request)
            direction.calculate { response, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                guard let route = response?.routes.first else{return}
                
                completion(route)
            }
        }
        
        func configurePloyline(withdestination destination: CLLocationCoordinate2D){
            guard let userLocation = userLocation else{return}
            self.getDestinationRoute(from: userLocation, to: destination) { route in
                // add polyline layer
                self.parent.mapView.addOverlay(route.polyline)
            }
        }
        
        
        
    }
    
    
    // end
}
