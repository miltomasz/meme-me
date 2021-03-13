//
//  MemeDetailsViewController.swift
//  MemeMe
//
//  Created by Tomasz Milczarek on 13/03/2021.
//  Copyright © 2021 Plumya. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {
    
    // MARK: Variables
    
    var meme: Meme?
    
    // MARK: IB
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupImageView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    private func setupImageView() {
        memeImageView.image = meme?.memedImage
    }
}
