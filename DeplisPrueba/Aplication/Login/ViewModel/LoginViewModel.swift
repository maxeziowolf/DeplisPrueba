//
//  LoginViewModel.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 07/11/22.
//

import Foundation

class LoginViewModel{

    enum codeError {
        case userAndPasswordEmpty
        case userEmpty
        case passwordEmpty
        case success
    }
    
    public func validInformation(user: String?, password: String?) -> codeError{
        
        guard let user = user else{
            return .userEmpty
        }
        
        guard let password = password else{
            return .passwordEmpty
        }
        
        if user.isEmpty && password.isEmpty {
            return .userAndPasswordEmpty
        }
        
        if user.isEmpty{
            return .userEmpty
        }
        
        if password.isEmpty{
            return .passwordEmpty
        }
        
        return .success
        
    }
    
    public func sendLoginUser(user: String, password: String, completion:  @escaping ((Bool)->()) ){
        ServiceCoordinator.sendAuthentication(user: user, password: password){ reponse in
            completion(reponse)
        }
    }
}
