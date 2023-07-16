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
    
    //A utility object for generating a list of completion strings based on a partial search string that you provide.
    private var searchCompleter = MKLocalSearchCompleter()
    
    
    var queryFragment: String = ""{
        didSet{
            // set user typed queryFragment to searchCompleter
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var currentLocation: String = ""
    
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
    
    
}

//MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel:MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.results = completer.results
        }
        
    }
    
}
