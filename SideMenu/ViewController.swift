//
//  ViewController.swift
//  SideMenu
//
//  Created by Andrei Volkau on 27.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let blurView = UIBlurEffect(style: .light)
    
    lazy var effectView = UIVisualEffectView(effect: blurView)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        let label = UILabel()
        label.text = "I'm label"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        effectView.alpha = 0
        effectView.frame = view.bounds
        view.addSubview(effectView)
        
        
        
    }


}

