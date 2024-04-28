//
//  SatnaTableViewCell.swift
//  Vremenska prognoya
//
//  Created by petar on 24/02/2021.
//

import UIKit

class SatnaTableViewCell: UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var models = [ViewController.Satno]()

//MARK: @IBOutlet
    @IBOutlet var collectionView : UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SatnaCollectionViewCell.nib(), forCellWithReuseIdentifier: SatnaCollectionViewCell.id)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//MARK:NIB & ID
    static let id = "SatnaTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SatnaTableViewCell",
                     bundle: nil)
    }
    
    func conf (with model: [ViewController.Satno]) {
        self .models = model
        self.collectionView.backgroundColor = .systemTeal
        collectionView.reloadData()
    
    }
//MARK: Collection View velicina i broj
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
//MARK: Collection View Celija
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SatnaCollectionViewCell.id, for: indexPath) as! SatnaCollectionViewCell
        cell.conf(with: models[indexPath.row])
        return cell
    }
    
}
