//
//  LottieViewController.swift
//  Todo
//
//  Created by Fan, Alessandro (IT - Milano) on 23/10/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import Foundation
import Lottie


class LottieViewController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = LOTAnimationView(name: "material_loading")
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        
        view.addSubview(animationView)
        
        animationView.play()
        performSegue(withIdentifier: "goToApp", sender: self)
        
    }
    
}
