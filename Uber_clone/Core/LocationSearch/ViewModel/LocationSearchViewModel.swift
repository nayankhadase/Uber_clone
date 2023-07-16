//
//  LocationSearchViewModel.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import SwiftUI
import MapKit


class LocationSearchViewModel: NSObject, ObservableObject{
    
    // initiate a search based on a set of partial search strings. That object stores any matches in its results property
    @Published var results = [MKLocalSearchCompletion]()
    
    //
    @Published var selectedLocation: CLLocationCoordinate2D?
    @Published var selectedLocationtext: String?
    
    //
    @Published var pickupTime = Date()
    @Published var dropOffTime = Date()
    
    //A utility object for generating a list of completion strings based on a partial search string that you provide.
    private var searchCompleter = MKLocalSearchCompleter()
    
    
    var queryFragment: String = ""{
        didSet{
            // set user typed queryFragment to searchCompleter
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var source: String = ""
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    // get coordinate for selected search
    func selectLocation(_ location: MKLocalSearchCompletion){
        selectedLocationtext = location.title
        locationSearch(forLocalSearchCompletion: location) { response, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let item = response?.mapItems.first else{return}
            DispatchQueue.main.async {
                self.selectedLocation = item.placemark.coordinate
            }
        }
    }
    
    fileprivate func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, complition: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: complition)
    }
    
    
    func calculateRidePrice(forType type: RideType) -> Double{
        guard let destination = selectedLocation else {return 0.0}
        guard let source = userLocation else {return 0.0}
        
        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        
        let distance = sourceLocation.distance(from: destinationLocation)
        return type.getPrice(for: distance)
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
            self.configureExpectedPickupAndDropoffTime(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configureExpectedPickupAndDropoffTime(with expectedTravelTime: Double){
        pickupTime = Date.now
        dropOffTime = Date.now.addingTimeInterval(expectedTravelTime)
        
    }
    
}

//MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel:MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.results = completer.results
        }
        
    }
    
}
