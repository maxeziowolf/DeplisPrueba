//
//  ModalLoadingViewController.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 10/11/22.
//

import UIKit

class ModalLoadingViewController: UIViewController {

    @IBOutlet weak var imageLoading: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0 ,options: [.repeat, .autoreverse ,.curveEaseInOut]){
            self.imageLoading.transform = self.imageLoading.transform.scaledBy(x: 2, y: 2)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
