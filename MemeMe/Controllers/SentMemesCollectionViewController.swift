//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Tomasz Milczarek on 11/03/2021.
//  Copyright © 2021 Plumya. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController, CreateMemeDelegate {
    
    // MARK: - IB

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Variables
    
    var memes: [Meme] {
        let delegate = UIApplication.shared.delegate
        guard let appDelegate = delegate as? AppDelegate else { return [] }
        
        return appDelegate.memes
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height: CGFloat = (view.frame.size.height - (3 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mainViewController = segue.destination as? MainViewController else { return }
        
        mainViewController.delegate = self
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as? MemeCollectionViewCell else { return UICollectionViewCell() }
    
        let meme = memes[indexPath.row]
        cell.memeImageView?.image = meme.memedImage
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let indexPath = (indexPath as NSIndexPath)
        let meme = memes[indexPath.row]
        
        MemeDetailsAction.go(with: self, meme: meme)
    }
    
    // MARK: UICollectionViewDelegate
    
    func refreshTable() {
        collectionView?.reloadData()
    }
}
