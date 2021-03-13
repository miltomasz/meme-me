//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Tomasz Milczarek on 02/03/2021.
//  Copyright © 2021 Plumya. All rights reserved.
//

import UIKit

protocol CreateMemeDelegate {
    
    func refreshTable()
    
}

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateMemeDelegate {
    
    // MARK: - Variables
    
    var memes: [Meme] {
        let delegate = UIApplication.shared.delegate
        guard let appDelegate = delegate as? AppDelegate else { return [] }
        
        return appDelegate.memes
    }
    
    // MARK: - IB

    @IBOutlet var memeTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        memeTableView.layoutMargins = UIEdgeInsets.zero
        memeTableView.separatorInset = UIEdgeInsets.zero
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mainViewController = segue.destination as? MainViewController else { return }
        
        mainViewController.delegate = self
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as? MemeTableViewCell else { return UITableViewCell() }
        
        let meme = memes[indexPath.row]
        cell.topLabel?.text = meme.topText
        cell.bottomLabel?.text = meme.bottomText
        cell.memeImageView?.image = meme.memedImage
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    // MARK: - CreateMemeDelegate
    
    func refreshTable() {
        memeTableView.reloadData()
    }
    
}
