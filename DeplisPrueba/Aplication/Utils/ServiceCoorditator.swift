//
//  ServiceCoorditator.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 07/11/22.
//

import UIKit

public class ServiceCoordinator {
    
    
    private let dateFormatter = DateFormatter()
    
    static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey = "649f9d447aa59de2a1fc8294413d3e05"
    static let keyExpireDate = "expireDate"
    static let keyToken = "expireToken"
    
    init(){
        
        //Date formatter information
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        //Obtener token de autenticacion
        getAuthenticationToken()
        
    }
    
    private func getAuthenticationToken(){
        
        let dateNow = Date.now
        let expireDate = UserDefaults.standard.string(forKey: ServiceCoordinator.keyExpireDate)
        
        if let expireDate = expireDate{
            
            if let date = dateFormatter.date(from: expireDate){
                
                if dateNow > date{
                    print("Expiro el token \n")
                    requestToken()
                }else{
                    print("Se obtuvo el token de manera local \n")
                }
                
            }else{
                print("No se tiene token de expiracion \n")
                requestToken()
            }
            
        }else{
            print("No se tiene token de expiracion \n")
            requestToken()
        }
        
    }
    
    private func requestToken(){
        
        let url = URL(string: "\(ServiceCoordinator.baseURL)authentication/token/new?api_key=\(ServiceCoordinator.apiKey)")
        
        let task = URLSession.shared.dataTask(with: url!){ data, response, error in
            
            if let error = error {
                
                print("\(error.localizedDescription)\n")
                
            }else{
                
                if let response = response {
                    let httpResponse = response as! HTTPURLResponse
                    
                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            
                            print("Respuesta:\n\(data.toString())\n")
                            
                            do{
                                
                                let info = try JSONDecoder().decode(Token.self, from: data)
                                
                                UserDefaults.standard.set(info.expiresAt, forKey: ServiceCoordinator.keyExpireDate)
                                UserDefaults.standard.set(info.requestToken, forKey: ServiceCoordinator.keyToken)
                                
                                print("Se obtuvo correctamente el token de expiracion")
                                
                            }catch{
                                
                            }
                        }
                        
                    }else{
                        
                        print("Error \(httpResponse.statusCode)")
                        
                        if let data = data {
                            print("Respuesta:\n\(data.toString())\n")
                        }
                    }
                    
                }else{
                    
                    self.requestToken()
                    
                }
                
            }
            
        }
        
        task.resume()
        
        
    }
    
    public static func sendAuthentication(user: String, password: String, completion:  @escaping ((Bool)->()) ){
        
        
        let url = URL(string: "\(ServiceCoordinator.baseURL)authentication/token/validate_with_login?api_key=\(ServiceCoordinator.apiKey)")
        
        let jsonBody: [String : Any] = [
            "username": user,
            "password": password,
            "request_token": UserDefaults.standard.string(forKey: ServiceCoordinator.keyToken)
        ]
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
            
            print("Cuerpo:\n\(jsonData.toString())\n")
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                
                if let error = error {
                    
                    print("\(error.localizedDescription)\n")
                    
                    completion(false)
                    
                }else{
                    
                    if let response = response {
                        let httpResponse = response as! HTTPURLResponse
                        
                        if httpResponse.statusCode == 200 {
                            if let data = data {
                                
                                print("Respuesta:\n\(data.toString())\n")
                                
                                do{
                                    completion(true)
                                    
                                }catch{
                                    
                                    completion(false)
                                    
                                }
                            }
                            
                        }else{
                            
                            print("Error \(httpResponse.statusCode)")
                            
                            if let data = data {
                                print("Respuesta:\n\(data.toString())\n")
                            }
                            
                            completion(false)
                        }
                        
                    }
                    
                }
                
            }
            
            task.resume()
        }catch{
            
            completion(false)
            
        }
        
    }
    
    
    static func getGenresn(completion:  @escaping ((GenreResponse?)->())){
        
        
        let url = URL(string: "\(ServiceCoordinator.baseURL)genre/movie/list?api_key=\(ServiceCoordinator.apiKey)&language=es-MX")

        
        do {
            
            let task = URLSession.shared.dataTask(with: url!){ data, response, error in
                
                if let error = error {
                    
                    print("\(error.localizedDescription)\n")
                    
                    completion(nil)
                    
                }else{
                    
                    if let response = response {
                        let httpResponse = response as! HTTPURLResponse
                        
                        if httpResponse.statusCode == 200 {
                            if let data = data {
                                
                                print("Respuesta:\n\(data.toString())\n")
                                
                                do{
                                    
                                    let info = try JSONDecoder().decode(GenreResponse.self, from: data)
                                    
                                    completion(info)
                                    
                                }catch{
                                    
                                    completion(nil)
                                    
                                }
                            }
                            
                        }else{
                            
                            print("Error \(httpResponse.statusCode)")
                            
                            if let data = data {
                                print("Respuesta:\n\(data.toString())\n")
                            }
                            
                            completion(nil)
                        }
                        
                    }
                    
                }
                
            }
            
            task.resume()
        }catch{
            
            completion(nil)
            
        }
        
    }
    
    static func getMovies(genresID: String,completion:  @escaping ((MovieReponse?)->())){
        
        
        let url = URL(string: "\(ServiceCoordinator.baseURL)discover/movie?api_key=\(ServiceCoordinator.apiKey)&language=es-MX&with_genres=\(genresID)")

        
        do {
            
            let task = URLSession.shared.dataTask(with: url!){ data, response, error in
                
                if let error = error {
                    
                    print("\(error.localizedDescription)\n")
                    
                    completion(nil)
                    
                }else{
                    
                    if let response = response {
                        let httpResponse = response as! HTTPURLResponse
                        
                        if httpResponse.statusCode == 200 {
                            if let data = data {
                                
                                print("Respuesta:\n\(data.toString())\n")
                                
                                do{
                                    
                                    let info = try JSONDecoder().decode(MovieReponse.self, from: data)
                                    
                                    completion(info)
                                    
                                }catch {
                                    print("JSONSerialization error:", error)
                                    completion(nil)
                                    
                                }
                            }
                            
                        }else{
                            
                            print("Error \(httpResponse.statusCode)")
                            
                            if let data = data {
                                print("Respuesta:\n\(data.toString())\n")
                            }
                            
                            completion(nil)
                        }
                        
                    }
                    
                }
                
            }
            
            task.resume()
        }catch{
            
            completion(nil)
            
        }
        
    }
    
    static func getDetailMovie(movieID: String,completion:  @escaping ((MovieDetailReponse?)->())){
        
        
        let url = URL(string: "\(ServiceCoordinator.baseURL)movie/\(movieID)?api_key=\(ServiceCoordinator.apiKey)&language=es-MX")

        
        do {
            
            let task = URLSession.shared.dataTask(with: url!){ data, response, error in
                
                if let error = error {
                    
                    print("\(error.localizedDescription)\n")
                    
                    completion(nil)
                    
                }else{
                    
                    if let response = response {
                        let httpResponse = response as! HTTPURLResponse
                        
                        if httpResponse.statusCode == 200 {
                            if let data = data {
                                
                                print("Respuesta:\n\(data.toString())\n")
                                
                                do{

                                    let info = try JSONDecoder().decode(MovieDetailReponse.self, from: data)

                                    completion(info)

                                }catch{

                                    completion(nil)

                                }
                            }
                            
                        }else{
                            
                            print("Error \(httpResponse.statusCode)")
                            
                            if let data = data {
                                print("Respuesta:\n\(data.toString())\n")
                            }
                            
                            completion(nil)
                        }
                        
                    }
                    
                }
                
            }
            
            task.resume()
        }catch{
            
            completion(nil)
            
        }
        
    }
    
}



