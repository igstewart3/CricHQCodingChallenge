//
//  DetailViewController.swift
//  CricHQCodingChallenge
//
//  Created by Ian Stewart on 10/10/2017.
//  Copyright © 2017 igstewart3. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    
    // MARK: UI components
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: Class components
    var movieData = [String:String]()
    
    // MARK: Override functions
    override func viewDidLoad() {
        
        // Show movie details
        titleLabel.text = movieData["title"]
        descriptionLabel.text = movieData["summary"]
        priceLabel.text = "Price: " + movieData["im:price"]!
        
        // Get release date
        let dateString = movieData["im:releaseDate"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:dateString!)!
        dateFormatter.dateFormat = "yyyy"
        let finalDate = dateFormatter.string(from: date)
        releasedLabel.text = "Released: " + finalDate
        
        // Retrieve movie image
        let urlString = movieData["im:image"]
        let url = URL(string: urlString!)
        let data = try? Data(contentsOf: url!)
        movieImage.image = UIImage(data: data!)
        
    }
    
    
}
