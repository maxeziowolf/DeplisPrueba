//
//  CompanyCollectionViewCell.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 10/11/22.
//

import UIKit

class CompanyCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "CompanyCollectionViewCell"

    @IBOutlet weak var imagePoster: UIImageView!
    
    
    public func setupInformation(information: ProductionCompany?){
        
        imagePoster.image = UIImage(named: "logo")
        
        if let path = information?.logoPath{
            imagePoster.downloadedFrom(link:"http://image.tmdb.org/t/p/w500\(path)", contentMode: .scaleToFill, animated: true)
        }
        
    }
}
