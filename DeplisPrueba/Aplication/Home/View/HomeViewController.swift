//
//  HomeViewController.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 07/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var uiCollectionMovie: UICollectionView!
    
    var generisResponse: GenreResponse?
    var movieReponse: MovieReponse?
    var segments:  [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        ServiceCoordinator.getGenresn(completion: { generisResponse in
            
            DispatchQueue.main.async {
                
                
                generisResponse?.genres.forEach({ genre in
                    self.segments.append(genre.name)
                })
                
                for segment in self.segments {
                    self.segmentedControl.insertSegment(withTitle: segment, at: self.segmentedControl.numberOfSegments, animated: true)
                }
                
                self.segmentedControl.selectedSegmentIndex = 0
                
                self.generisResponse = generisResponse
                
                print(String(generisResponse?.genres.first(where: {$0.name == self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)})?.id ?? 0))
                
                ServiceCoordinator.getMovies(genresID: String(generisResponse?.genres.first(where: {$0.name == self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)})?.id ?? 0) ) { movieReponse in
                    print("")
                    
                    DispatchQueue.main.async {
                        self.movieReponse = movieReponse
                        print("\(movieReponse?.results?.count)")
                        self.uiCollectionMovie.reloadData()
                    }
                }
                
            }
            
        })
        
        
    }
    
    private func setupUI(){
        uiCollectionMovie.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        uiCollectionMovie.delegate = self
        uiCollectionMovie.dataSource = self
        uiCollectionMovie.collectionViewLayout = UICollectionViewFlowLayout()

        
        segmentedControl.removeAllSegments()
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for:.selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        print(String(generisResponse?.genres.first(where: {$0.name == self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)})?.id ?? 0))
        
        ServiceCoordinator.getMovies(genresID: String(generisResponse?.genres.first(where: {$0.name == self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)})?.id ?? 0) ) { movieReponse in
            DispatchQueue.main.async {
                self.movieReponse = movieReponse
                self.uiCollectionMovie.reloadData()
            }
        }
        
    }

    @IBAction func onOptionsClicked(_ sender: Any) {
        
        let modal = ModalMenuViewController(nibName: "ModalMenuViewController", bundle: nil)
        modal.modalPresentationStyle = .overCurrentContext
        modal.modalTransitionStyle = .coverVertical
        modal.delegate = self
        
        self.navigationController?.present(modal, animated: true)
        
    }
    
}

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieReponse?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        cell.setupInfo(info: movieReponse?.results?[indexPath.row])
        
        return cell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        
        vc.information = movieReponse?.results?[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 10 )/2 , height: 400)
    }

    
}

extension HomeViewController: ModalMenuViewControllerDelegate{
    func onCancelClicked() {
        self.navigationController?.dismiss(animated: true)
    }
    
    func onShowView() {
        
        self.navigationController?.dismiss(animated: true){
            let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            vc.modalPresentationStyle = .formSheet
            
            self.navigationController?.present(vc , animated: true)
        }
    }
    
    func onLogout() {
        self.navigationController?.dismiss(animated: true){
            let secondView = LoginViewController(nibName: "LoginViewController", bundle: nil)
            
            let navigationControll = UINavigationController(rootViewController: secondView)
            
            navigationControll.navigationBar.isHidden = true
            
            UIApplication.shared.windows.first?.rootViewController = navigationControll
            
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    
}
