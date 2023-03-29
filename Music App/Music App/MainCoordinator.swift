//
//  MainCoordinator.swift
//  Music App
//
//  Created by Дархан Есенкул on 28.03.2023.
//

import Foundation
import UIKit


class MainCoordinator: Coordinator{
    var children: [Coordinator]? = nil
    
    var navigationController: UINavigationController?
    
    func eventOccured(with type: Event) {
        switch type{
        case .musicInfoTapped:
            var vc: UIViewController & Coordinating = MusicInfoViewController()
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func start() {
        let vc: ViewController & Coordinating = ViewController()
        
        vc.coordinator = self
        
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    
}
