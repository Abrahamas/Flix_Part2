//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Mac on 6/24/1397 AP.
//  Copyright © 1397 Abraham Asmile. All rights reserved.
//
import AlamofireImage
import UIKit


class NowPlayingViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var acIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
         //Start the activity indicator
        if acIndicator.isAnimating == true
        {

                acIndicator.stopAnimating()
                acIndicator.isHidden = true

        }
        else {
            acIndicator.isHidden = false
            acIndicator.startAnimating()

        }
    
        
       
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullTorefresh(_:)) , for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.estimatedRowHeight = 200
        fetchMovies()
        
    }//
    @objc func didPullTorefresh (_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed" )!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request return
            if let error = error {
                if self.movies == nil{
                    self.acIndicator.startAnimating()
                }
                print (error.localizedDescription)
               
            }else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                let movies = dataDictionary ["results"] as! [[String: Any]]
                self.movies = movies
                self.acIndicator.stopAnimating()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURLString + posterPathString)!
        
        cell.posterImageView.af_setImage(withURL: posterURL)
    
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
        let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

}


