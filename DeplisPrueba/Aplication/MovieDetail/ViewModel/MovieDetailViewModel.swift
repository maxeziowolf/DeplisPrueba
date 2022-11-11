//
//  MovieDetailViewModel.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 10/11/22.
//

import Foundation

class MovieDetailViewModel{
    
    public var updateList = {()->() in}
    public var generesText = ""{
        didSet{
            updateList()
        }
    }
    public var productionCompanies: [ProductionCompany]? {
        didSet{
            updateList()
        }
    }
    
    
    public func getInformatio(id: Int?){
        
        ServiceCoordinator.getDetailMovie(movieID: String(id ?? 0)){[weak self] movieDetailReponse in
            

            DispatchQueue.main.async {
                
                var generesText = ""
                
                movieDetailReponse?.genres?.forEach({ genre in
                    generesText += "\(genre.name), "
                })
                
                self?.generesText = generesText
                self?.productionCompanies = movieDetailReponse?.productionCompanies
            }
            
        }
        
    }
    
}
