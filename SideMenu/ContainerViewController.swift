//
//  ContainerViewController.swift
//  SideMenu
//
//  Created by Andrei Volkau on 27.01.2021.
//

import UIKit

class ContainerViewController: UIViewController {
    
    enum State {
        case opened, closed
    }
    
    var state: State = .closed
    let menuWidth: CGFloat = 160.0
    
    let sideMenuController: UIViewController
    let mainController: UIViewController
    
    var isOpening: Bool = false
 
    init(sideMenu: UIViewController, main: UIViewController) {
        sideMenuController = sideMenu
        mainController = main
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(mainController)
        view.addSubview(mainController.view)
        mainController.didMove(toParent: self)
        
        addChild(sideMenuController)
        view.addSubview(sideMenuController.view)
        sideMenuController.didMove(toParent: self)
        
        
        sideMenuController.view.frame = .init(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view!.superview)

        /// If the user swipe it to open, then translation.x > 0 and isOpening = true => progress has positive value.
        /// If the user swipe it to close, then translation.x < 0 and isOpening = false => progress has positive value.
        var progress = (translation.x / menuWidth) * (state == .closed ? 1.0 : -1.0)
        //makes bounds for progress value 0.0 < progress < 1.0
        progress = min(max(progress, 0.0), 1.0)
        
        switch recognizer.state {
        case .began:
            //switch isOpening either true or false, depends on the current state.
            let isOpen = floor(sideMenuController.view.frame.origin.x / menuWidth) == 0
            state = isOpen ? .opened : .closed
        case .changed:
            setMenu(toPercent: state == .closed ? progress: (1 - progress))
        case .ended: fallthrough
        case .cancelled: fallthrough
        case .failed:
            var targetProgress: CGFloat
            if state == .closed {
                targetProgress = progress < 0.5 ? 0.0 : 1.0 //when open
            } else {
                targetProgress = progress < 0.5 ? 1.0 : 0.0 //when closing
            }
            animate(targetProgress)
        default:
            break
        }
    }
    
    func animate(_ targetProgress: CGFloat) {
        UIView.animate(withDuration: 0.4) { [self] in
            self.setMenu(toPercent: targetProgress)
            
        }
        
    }
    
    
    func setMenu(toPercent percent: CGFloat) {
        sideMenuController.view.frame.origin.x = menuWidth * CGFloat(percent) - menuWidth
        (mainController as! ViewController).effectView.alpha = percent / 2
    }
    
    
}
