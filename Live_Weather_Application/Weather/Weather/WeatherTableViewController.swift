//
//  WeatherTableViewController.swift
//  Weather
//
//  Created by Prateek Gupta on 08/03/19.
//  Copyright © 2019 Prateek Gupta. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var forecastData = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        updateWeatherForLocation(location: "New Delhi")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let locationText = searchBar.text, !locationText.isEmpty{
            // Update weather for location
            updateWeatherForLocation(location: locationText)
        }
    }
    
    func updateWeatherForLocation(location: String){
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error == nil{
                if let location = placemarks?.first?.location{
                    Weather.forecast(withLocation: location.coordinate, completion: { (results: [Weather]?) in
                        if let weatherData = results{
                            self.forecastData = weatherData
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let weatherObject = forecastData[indexPath.section]
        cell.textLabel?.text = weatherObject.summary
        let words = weatherObject.summary.components(separatedBy: " ")
        
        for word in words{
            if word == "Rain" || word == "rain"{
                print("yes")
            }
        }
        
        let celcius = (weatherObject.temperature - 32)*(5/9)
        cell.detailTextLabel?.text = "\(Int(celcius)) °C"
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        
        return cell
    }
}
