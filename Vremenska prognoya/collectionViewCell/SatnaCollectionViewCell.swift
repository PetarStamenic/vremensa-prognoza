//
//  SatnaCollectionViewCell.swift
//  Vremenska prognoya
//
//  Created by petar on 04/03/2021.
//

import UIKit

class SatnaCollectionViewCell: UICollectionViewCell {
    //MARK:@IBOutlet
    @IBOutlet var ico : UIImageView!
    @IBOutlet var hrs : UILabel!
    @IBOutlet var temp : UILabel!

    func conf(with model: ViewController.Satno){
        self.backgroundColor = .systemTeal
//MARK: text
        self.temp.text = "\(Int(model.temp-273.15))°"
        self.hrs.text = whattime(Date(timeIntervalSince1970: Double(model.dt)))
        
//MARK: text color
        self.temp.textColor = .white
        self.hrs.textColor = .white
        
//MARK: text alignment
        self.temp.textAlignment = .center
        self.hrs.textAlignment = .center
        
//MARK: ikonice
        self.ico.contentMode = .scaleAspectFit
        self.ico.image = UIImage(named: model.weather.first!.main)
        
    }
//MARK: NIB & ID
    static let id = "SatnaCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SatnaCollectionViewCell",
                     bundle: nil)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func whattime(_ date: Date?) -> String{
        guard let InDate = date else {
            return""
        }
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm"
        return formater.string(from: InDate)
    }

}
