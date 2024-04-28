//
//  ViewController.swift
//  Vremenska prognoya
//
//  Created by Petar on 13/02/2021.
//

import UIKit
import CoreLocation
import CoreData
class ViewController: UIViewController, CLLocationManagerDelegate , UITableViewDataSource , UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .systemTeal
        view.backgroundColor = .systemTeal
        
        
        if ConectionControler.shared.isOnline {
            print("da")
            
            locate()
        }
        else
        {
            
            
        }
//MARK: registracija nibova i celija
        table.register(SatnaTableViewCell.nib(), forCellReuseIdentifier: SatnaTableViewCell.id)
        table.register(DnevnaTableViewCell.nib(), forCellReuseIdentifier: DnevnaTableViewCell.id)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }


    @IBOutlet var table : UITableView!
    
    // strukture vramena ybog lakseg otpakivanja json fajla
    
//MARK: Vreme
    struct Vreme : Codable {
        let lat : Float
        let lon : Float
        let timezone : String
        let timezone_offset : Int
        let current : Trenutno
        let hourly : [Satno]
        let daily : [Dnevno]
        
    }
//MARK: Trenutno
    struct Trenutno : Codable {
        let dt : Int
        let sunrise : Int
        let sunset : Int
        let temp : Double
        let feels_like : Double
        let pressure : Int
        let humidity : Int
        let dew_point : Double
        let uvi : Double
        let clouds : Int
        let visibility : Int
        let wind_speed : Double
        let wind_deg : Int
        let weather : [Nesto]
        
    }
//MARK: Nesto
    struct Nesto : Codable {
        let id : Int
        let main : String
        let description : String
        let icon : String
        
    }
//MARK: Satno
    struct Satno : Codable {
        let dt : Int
        let temp : Double
        let feels_like : Double
        let pressure : Int
        let humidity : Int
        let dew_point : Double
        let uvi : Double
        let clouds : Int
        let visibility : Int
        let wind_speed : Double
        let wind_deg : Int
        let weather : [Nesto]
        let pop : Double
    }
//MARK: Dnevno
    struct Dnevno : Codable {
        let dt : Int
        let sunrise : Int
        let sunset : Int
        let temp : Temperatura
        let feels_like : feelsbadman
        let pressure : Int
        let humidity : Int
        let dew_point : Double
        let weather : [Nesto]
        let clouds : Int
        let pop : Double
        let uvi : Double
        
    }
//MARK: Temperatura
    struct Temperatura : Codable {
        let day : Double
        let min : Double
        let max : Double
        let night : Double
        let eve : Double
        let morn : Double
    }
//MARK: Feels like
    struct feelsbadman : Codable {
        let day : Double
        let night : Double
        let eve : Double
        let morn : Double
    }
    
    
    var Model = [Dnevno]()
    
    
//MARK: -Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 /*collection table view cell*/}
        return Model.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SatnaTableViewCell.id , for: indexPath) as! SatnaTableViewCell
            cell.conf(with: curHWeather)
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: DnevnaTableViewCell.id , for: indexPath) as! DnevnaTableViewCell
        cell.conf(with: Model[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {return 120}
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//MARK: -core location
    let LocationManager = CLLocationManager()
    
    var curcoords : CLLocation?
    
    var badapiihavetomakelocationseparatlz : String?
    
    var curWeather : Trenutno?
    var curHWeather = [Satno]()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        if !locations.isEmpty , curcoords == nil {
            curcoords = locations.first
            //crash mi se ako ne yaustavim mozda je do vbox
            LocationManager.stopUpdatingLocation()
            getweather()
        }
    }
    
    func getweather() {
        //provera ako nemamo koordinate
        guard let curcoords = curcoords else { return }
            let x = curcoords.coordinate.longitude
            let y = curcoords.coordinate.latitude
        
//MARK:-API
            let apikey = "807868d9f39723947a2a053d2a70d2f6"
            let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(y)&lon=\(x)&exclude=minutely,alerts&appid=\(apikey)"
        
            URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data , response , error) in
            //validacija
            guard let data = data, error == nil else {
                print("Greska prilikom preuyimanja informacija")
                return
                }
            
            //konveryija
            var json : Vreme?
            do {
                json = try JSONDecoder().decode(Vreme.self, from: data)
                
                
            }
            catch {
                print("\(error)")
            }
                
                guard let result = json else {
                    return
                }
                let entries = result.daily
                self.Model.append(contentsOf: entries)
                print(result.current.dt)
                let moralokacijaposebno = result.timezone
                let PoSatu = result.hourly
                let BasSadaVreme = result.current
                self.curWeather = BasSadaVreme
                self.curHWeather = PoSatu
                self.badapiihavetomakelocationseparatlz = moralokacijaposebno
//MARK: - Update interface
                DispatchQueue.main.async {
                    self.table.reloadData()
                    self.table.tableHeaderView = createHeader()
                    self.table.tableFooterView = createFooter()
                }
            }).resume()
//MARK:-Header
        func createHeader() -> UIView {
            let Header = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: view.frame.size.width))
            Header.backgroundColor = .systemTeal
            let locationUILabel = UILabel(frame: CGRect(x: 15,
                                                        y: 15,
                                                        width: view.frame.size.width-30,
                                                        height: view.frame.size.width/4))
            let tempUILabel = UILabel(frame: CGRect(x: 15,
                                                    y: 20+locationUILabel.frame.size.height,
                                                    width: view.frame.size.width-30,
                                                        height: 100))
            let minmaxUILabel = UILabel(frame: CGRect(x: 15,
                                                      y: 125+locationUILabel.frame.size.height,
                                                      width: view.frame.size.width-30,
                                                      height: 30))
            let weatherUILabel = UILabel(frame: CGRect(x: 15,
                                                       y: 130+locationUILabel.frame.size.height+30,
                                                       width: view.frame.size.width-30,
                                                       height: view.frame.size.width/6))
//MARK:- Header subview
            Header.addSubview(locationUILabel)
            Header.addSubview(tempUILabel)
            Header.addSubview(minmaxUILabel)
            Header.addSubview(weatherUILabel)
//MARK:- Header text alignement
            weatherUILabel.textAlignment = .center
            minmaxUILabel.textAlignment = .center
            tempUILabel.textAlignment = .center
            locationUILabel.textAlignment = .center
            
//MARK:- Header text color
            locationUILabel.textColor = .white
            tempUILabel.textColor = .white
            minmaxUILabel.textColor = .white
            weatherUILabel.textColor = .white
            
//MARK:- Header text font
            tempUILabel.font = UIFont(name: "Arial", size: 130)
            locationUILabel.font = UIFont(name: "Times New Roman", size: 25)
            
//MARK:- Header text
            //nalazi se ne u current location nego u general info
            var locationstring = self.badapiihavetomakelocationseparatlz
            locationUILabel.text = locationstring
            tempUILabel.text = "\(Int(curWeather!.temp-273.15))°"
            minmaxUILabel.text = "feels like  \(Int(curWeather!.feels_like-273.15))°"
            weatherUILabel.text = curWeather!.weather.first!.description
            
            
            return Header
        }
        
        
//MARK: -Footer
        func createFooter() -> UIView {
            
            let gifURL = "https://i.gifer.com/3SmH.gif"
            let Footer = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: 400))
            Footer.backgroundColor = .systemTeal
            let MoistUILabel = UILabel(frame: CGRect(x: 15,
                                                        y: 15,
                                                        width: view.frame.size.width-30,
                                                        height: view.frame.size.width/4))
            let UVUILabel = UILabel(frame: CGRect(x: 15,
                                                    y: 20+MoistUILabel.frame.size.height,
                                                    width: view.frame.size.width-30,
                                                        height: 100))
            //MARK: progress bar
            let SunProgress = UIProgressView(progressViewStyle: .bar)
            var sunpoint : Float = 0.0
            if curWeather!.dt > curWeather!.sunset { sunpoint = 1.0 }
            else {sunpoint = (Float(curWeather!.dt-curWeather!.sunrise)/Float(curWeather!.sunset-curWeather!.sunrise))}
            SunProgress.trackTintColor = .white
            SunProgress.progressTintColor = .yellow
            SunProgress.frame = CGRect(x: 80, y:250 , width: view.frame.size.width - 180, height: 20)
            SunProgress.setProgress(sunpoint , animated: true)
            let SunriseUILabel = UILabel(frame: CGRect(x: 20,
                                                       y: 235,
                                                       width: 50,
                                                       height: 30))
            let SunsetUILabel = UILabel(frame: CGRect(x: 80 + SunProgress.frame.width + 10,
                                                      y: 235,
                                                      width: 50,
                                                      height: 30))
            let minmaxUILabel = UILabel(frame: CGRect(x: 15,
                                                      y: 125+MoistUILabel.frame.size.height,
                                                      width: view.frame.size.width-30,
                                                      height: 30))
            let windspeedlabel = UILabel(frame: CGRect(x: 15,
                                                       y: 300,
                                                       width: view.frame.size.width - 30,
                                                       height: 30))
            let winddeglabel = UILabel(frame: CGRect(x: 15,
                                                       y: 350,
                                                       width: view.frame.size.width - 30,
                                                       height: 30))
            
//MARK:- Footer subview
            Footer.addSubview(windspeedlabel)
            Footer.addSubview(winddeglabel)
            Footer.addSubview(MoistUILabel)
            Footer.addSubview(UVUILabel)
            Footer.addSubview(minmaxUILabel)
            Footer.addSubview(SunProgress)
            Footer.addSubview(SunsetUILabel)
            Footer.addSubview(SunriseUILabel)
//MARK:- Footer text alignement
            minmaxUILabel.textAlignment = .center
            UVUILabel.textAlignment = .center
            MoistUILabel.textAlignment = .center
            windspeedlabel.textAlignment = .right
            winddeglabel.textAlignment = .right
            SunsetUILabel.textAlignment = .center
            SunriseUILabel.textAlignment = .center
//MARK:- Footer text color
            windspeedlabel.textColor = .white
            winddeglabel.textColor = .white
            SunsetUILabel.textColor = .white
            SunriseUILabel.textColor = .white
            UVUILabel.textColor = .white
            MoistUILabel.textColor = .white
            minmaxUILabel.textColor = .white
//MARK:- Footer text font
            MoistUILabel.font = UIFont(name: "Times New Roman", size: 25)
            UVUILabel.font = UIFont(name: "Arial", size: 30)
            
            
//MARK:- Footer text
            windspeedlabel.text = "Wind speed : \(curWeather!.wind_speed) km/h"
            winddeglabel.text = "Wind direction \(curWeather!.wind_deg)°"
            SunriseUILabel.text = whattime(Date(timeIntervalSince1970: Double(curWeather!.sunrise)))
            SunsetUILabel.text = whattime(Date(timeIntervalSince1970: Double(curWeather!.sunset)))
            MoistUILabel.text = "Humidity : \(curWeather!.humidity) %"
            UVUILabel.text = "UV Index :\(curWeather!.uvi)"
            minmaxUILabel.text = "Sun progress"
            
            return Footer
        }
    }
    func locate () {
        LocationManager.delegate = self
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.startUpdatingLocation()
    }
    
//MARK: Date formater
    func whattime(_ date: Date?) -> String{
        guard let InDate = date else {
            return""
        }
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm"
        return formater.string(from: InDate)
    }
    
    
   

}

