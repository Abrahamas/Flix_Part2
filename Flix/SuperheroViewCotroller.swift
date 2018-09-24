//
//  SuperheroViewCotroller.swift
//  Flix
//
//  Created by Mac on 6/26/1397 AP.
//  Copyright © 1397 Abraham Asmile. All rights reserved.
//

import UIKit
import AlamofireImage

class SuperheroViewCotroller: UIViewController, UICollectionViewDataSource {
    var movies: [[String: Any]] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self 
 
   let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerline: CGFloat = 3
        let interItemSpacingTotal = layout.minimumLineSpacing * (cellsPerline - 1)
        let width = collectionView.frame.size.width / cellsPerline - interItemSpacingTotal / cellsPerline
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        

        fetchMovies()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        
                let movie = movies[indexPath.item]
        
                if let posterPathString = movie["poster_path"] as? String {
                    let baseURLString = "https://image.tmdb.org/t/p/w500"
                    let posterURL = URL(string: baseURLString + posterPathString)!
                    print("posterURL ",movie)
                    cell.posterImageView.af_setImage(withURL: posterURL)
        
                }
                return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//
//    }
    
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed" )!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request return
            if let error = error {
//               if self.movies == nil{
//                   //self.acIndicator.startAnimating()
//                }
                print (error.localizedDescription)
                
            }else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                let movie = dataDictionary ["results"] as! [[String: Any]]
                self.movies = movie
//                movies = movie as! [[String: Any]]
//                print("****************************",self.movies)
               // self.acIndicator.stopAnimating()
                self.collectionView.reloadData()
               // self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
