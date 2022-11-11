//
//  MovieCollectionViewCell.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 09/11/22.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "MovieCollectionViewCell"

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelRate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    public func setupInfo(info: Result?){
        
        imagePoster.layer.cornerRadius = 12
        view.layer.cornerRadius = 12
        
        imagePoster.image = UIImage(named: "logo")
        
        imagePoster.downloadedFrom(link:"http://image.tmdb.org/t/p/w500\(info?.posterPath ?? "")", contentMode: .scaleToFill, animated: true)
        
        labelTitle.text = (info?.title ?? "Sin titulo")
        labelDate.text = info?.releaseDate ?? "Sin fecha"
        labelRate.text = "✭ \(info?.voteAverage ?? 0.0)"
        labelDescription.text = (info?.overview ?? "Sin descripcion").isEmpty ? "Sin descripcion" : (info?.overview ?? "Sin descripcion")
        
    }
    
}
