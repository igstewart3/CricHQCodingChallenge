//
//  TableViewController.swift
//  CricHQCodingChallenge
//
//  Created by Ian Stewart on 09/10/2017.
//  Copyright © 2017 igstewart3. All rights reserved.
//

import UIKit

class TableViewController : UITableViewController {
    
    // MARK: Class components
    let rssParser = RSSParser()
    
    // MARK: Completion handlers
    /**
     Handles the result of the RSS parsing.
     
     - parameters:
        - bool: The result of the parsing
     */
    func parseComplete(bool: Bool) {
        
        // Reload table to show data
        self.tableView.reloadData()
        
    }
    
    // MARK: Override functions
    override func viewDidLoad() {
        
        // Load RSS elements
        let url = URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topMovies/xml")
        rssParser.parseRSSfromURL(rssUrl: url!, with: parseComplete)
        
        // Register XIB for cells
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier: "reuseCell")
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // Only ever one section
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Number of parsed data elements
        return rssParser.parsedData.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create reusable cell for each row
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        
        // Update cell with movie details
        (cell as! TableViewCell).movieNameLabel.text = rssParser.parsedData[indexPath.item]["title"]
        (cell as! TableViewCell).movieDescLabel.text = rssParser.parsedData[indexPath.item]["summary"]

        // Retrieve and display movie image
        let urlString = rssParser.parsedData[indexPath.item]["im:image"]
        let url = URL(string: urlString!)
        let data = try? Data(contentsOf: url!)
        (cell as! TableViewCell).movieImage.image = UIImage(data: data!)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // Add header
        if section == 0 {
            return "Top Movies"
        }
        else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Move to detail view controller when item is selected
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.movieData = rssParser.parsedData[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
}
