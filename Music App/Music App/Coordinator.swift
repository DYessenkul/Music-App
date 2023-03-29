//
//  Coordinator.swift
//  Music App
//
//  Created by Дархан Есенкул on 28.03.2023.
//

import Foundation
import UIKit

enum Event{
    case musicInfoTapped
}

protocol Coordinator{
    var navigationController: UINavigationController? {get set}
    var children: [Coordinator]? {get set}
    
    func eventOccured(with type: Event)
    
    func start()
}

protocol Coordinating{
    var coordinator: Coordinator?{get set}
}
