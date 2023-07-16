//
//  MapViewRepresentable.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import SwiftUI
import MapKit


struct MapViewRepresentable: UIViewRepresentable{
    // this is not publishing anything just observing
    // so we publish userlocation from location manager
    
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    @Binding var mapState: MapViewState
    
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
            switch mapState {
            case .noInput:
                viewModel.selectedLocation = nil
                viewModel.selectedLocationtext = nil
                viewModel.queryFragment = ""
                viewModel.results = []
                context.coordinator.clearMapviewAndsetRegion()
                break
            case .locationSelected:
                print("location selected")
                // add annotation
                context.coordinator.addAndSelectAnnotation(withCoordinate: selectedLocation)
                context.coordinator.configurePloyline(withdestination: selectedLocation)
                break
            case .searchingForLocation:
                print("searching for location")
                break
            case .polylineAdded:
                break
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    //MARK: - Coordinator, MKMapViewDelegate
    
    class Coordinator: NSObject, MKMapViewDelegate{
        let parent: MapViewRepresentable
        var userLocation: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let coordinate = userLocation.coordinate
            self.userLocation = coordinate
            
            // create region center around specific coordinate
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            currentRegion = region
            if self.parent.mapState != .polylineAdded{
                self.parent.mapView.setRegion(region, animated: true) // update region for map view
            }
        }
        
        //(delegate method which tels map to draw overlay) use to draw a overlay on the map
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .systemBlue
            render.lineWidth = 6
            return render
        }
        
        //MARK: - helper
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
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
        
        
        
        func configurePloyline(withdestination destination: CLLocationCoordinate2D){
            guard let userLocation = userLocation else{return}
            
            // remove all overlays / polyline
            self.parent.mapView.removeOverlays(self.parent.mapView.overlays)
            
            self.parent.viewModel.getDestinationRoute(from: userLocation, to: destination) { route in
                // add polyline as Overlay
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 40, bottom: 500, right: 40))
                self.parent.mapView.setVisibleMapRect(rect, animated: true)
            }
        }
        
        func clearMapviewAndsetRegion(){
            self.parent.mapView.removeAnnotations(self.parent.mapView.annotations)
            self.parent.mapView.removeOverlays(self.parent.mapView.overlays)
            if let currentRegion = currentRegion{
                self.parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        
        
    }
    
    
    // end
}
