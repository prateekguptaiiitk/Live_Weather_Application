//
//  WeatherTableViewController.swift
//  Weather
//
//  Created by Prateek Gupta on 08/03/19.
//  Copyright © 2019 Prateek Gupta. All rights reserved.
//
// <div>Icons made by <a href="https://www.flaticon.com/authors/vectors-market" title="Vectors Market">Vectors Market</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>

//<div>Icons made by <a href="https://www.freepik.com/" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UISearchBarDelegate {
    
    var f = 0
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
            //self.view.layer.sublayers?.popLast()
//            if f == 1{
//
//            }
//            [self.view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)]
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
                rainDrops()
                f = 1
            }
            else if word == "Snow" || word == "snow"{
                snowFlakes()
                f = 2
            }
        }
        
        let celcius = (weatherObject.temperature - 32)*(5/9)
        cell.detailTextLabel?.text = "\(Int(celcius)) °C"
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        
        return cell
    }
    
    func rainDrops()
    {
        let emitter = RainEmitter.get(with: #imageLiteral(resourceName: "drop"))
        emitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.addSublayer(emitter)
    }
    
    func snowFlakes()
    {
        let emitter = SnowEmitter.get(with: #imageLiteral(resourceName: "snowflake"))
        emitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.addSublayer(emitter)
    }
}
