//
//  DnevnaTableViewCell.swift
//  Vremenska prognoya
//
//  Created by petar on 24/02/2021.
//

import UIKit

class DnevnaTableViewCell: UITableViewCell {
    
//MARK: @IBOutlet
    @IBOutlet var dazLabel : UILabel!
    @IBOutlet var maxLabel : UILabel!
    @IBOutlet var minLabel : UILabel!
    @IBOutlet var ico : UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemTeal
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//MARK:NIB & ID
    
    static let id = "DnevnaTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DnevnaTableViewCell",
                     bundle: nil)
    }
    
    func conf (with model: ViewController.Dnevno) {
        
//MARK: text
        self.minLabel.text = "\(Int(model.temp.min - 273.15))°"
        self.maxLabel.text = "\(Int(model.temp.max - 273.15))°"
        self.dazLabel.text = whatday(Date(timeIntervalSince1970: Double(model.dt)))
        
//MARK: text color
        self.dazLabel.textColor = .white
        self.minLabel.textColor = UIColor(displayP3Red: 150.0, green: 150.0, blue: 150.0, alpha: 1.0)
        self.maxLabel.textColor = .white
        
//MARK: text font
        self.dazLabel.font = UIFont.systemFont(ofSize: 26)
        
        
//MARK: ikonice
        let icon = model.weather.first?.main
        self.ico.image = UIImage(named: icon!)
        self.ico.contentMode = .scaleAspectFit

    }
//MARK: date formater
    func whatday(_ date: Date?) -> String{
        guard let InDate = date else {
            return""
        }
        let formater = DateFormatter()
        formater.dateFormat = "EEE, d MMM"
        return formater.string(from: InDate)
    }
}

