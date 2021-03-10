//
//  Coordinator.swift

import UIKit

class Coordinator: CoordinatorProtocol {
    
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    
    deinit {
        print("deinit " + String(describing:self))
    }
    
    func start() {
        
    }
    
    var rootControoler: Presentable? {
        return nil
    }
    
    // add only unique object
    func addDependency(_ coordinator: CoordinatorProtocol) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: CoordinatorProtocol?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        // Clear child-coordinators recursively
        if let coordinator = coordinator as? Coordinator, !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators
                .filter({ $0 !== coordinator })
                .forEach({ coordinator.removeDependency($0) })
        }
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
