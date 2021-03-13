//
//  MemeDetailsAction.swift
//  MemeMe
//
//  Created by Tomasz Milczarek on 13/03/2021.
//  Copyright © 2021 Plumya. All rights reserved.
//

import UIKit

class MemeDetailsAction {
    
    class func go(with controller: UIViewController, meme: Meme) {
        guard let detailController = controller.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as? MemeDetailsViewController else { return }
        
        detailController.meme = meme
        detailController.hidesBottomBarWhenPushed = true

        controller.navigationController?.pushViewController(detailController, animated: true)
    }
    
}
