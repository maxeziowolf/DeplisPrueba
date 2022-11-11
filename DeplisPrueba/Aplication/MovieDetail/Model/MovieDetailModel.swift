//
//  MovieDetailModal.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 10/11/22.
//

import Foundation

// MARK: - MovieDetailReponse
struct MovieDetailReponse: Codable {
    let genres: [Genre]?
    let productionCompanies: [ProductionCompany]?

    enum CodingKeys: String, CodingKey {
        case genres
        case productionCompanies = "production_companies"
    }
}


// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath: String?
    let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
