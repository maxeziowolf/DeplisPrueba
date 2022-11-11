//
//  ModalMenuViewController.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 10/11/22.
//

import UIKit

protocol ModalMenuViewControllerDelegate{
    func onCancelClicked()
    func onShowView()
    func onLogout()
}

class ModalMenuViewController: UIViewController {
    
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var bottonButton: UIButton!
    
    var delegate: ModalMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content.layer.cornerRadius = 18
        bottonButton.layer.cornerRadius = 22
        
    }
    
    @IBAction func onClickedShowProfile(_ sender: Any) {
        delegate?.onShowView()
    }
    

    @IBAction func onLogoutClicked(_ sender: Any) {
        delegate?.onLogout()
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        delegate?.onCancelClicked()
    }
    


}
