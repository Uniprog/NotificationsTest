//
//  Router.swift

import UIKit

final class Router: NSObject, Routerable {
    
    private(set) weak var rootController: UINavigationController?
    
    //! Completions to call after pop action
    private var completions: [UIViewController : () -> Void]
    
    deinit {
        print("deinit " + String(describing:self))
    }
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }
    
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    func present(_ module: Presentable?) {
        present(module, animated: true)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        controller.modalPresentationStyle = .fullScreen
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ module: Presentable?)  {
        push(module, animated: true)
    }
    
    func push(_ module: Presentable?, hideBottomBar: Bool)  {
        push(module, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, hideBottomBar: false, completion: completion)
    }
    
    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        
        //! Set completion to call it after pop
        if let completion = completion {
            completions[controller] = completion
        }
        controller.hidesBottomBarWhenPushed = hideBottomBar
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func popModule()  {
        popModule(animated: true)
    }
    
    func popModule(animated: Bool)  {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                //! Run completion for all controllers to handle additional action on pop
                runCompletion(for: controller)
            }
        }
    }
    
    func addChild(_ module: Presentable?, to:Presentable?, animated:Bool) {
        guard let controller = module?.toPresent(), var parrent:UIViewController = rootController else { return }
        
        if let to = to?.toPresent() {
            parrent = to
        }
        
        parrent.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        parrent.view.addSubview(controller.view)
        
        controller.view.topAnchor.constraint(equalTo: parrent.view.topAnchor, constant: 0).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: parrent.view.bottomAnchor, constant: 0).isActive = true
        controller.view.leadingAnchor.constraint(equalTo: parrent.view.leadingAnchor, constant: 0).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: parrent.view.trailingAnchor, constant: 0).isActive = true
        
        controller.view.alpha = 0.0
        controller.beginAppearanceTransition(true, animated: true)
        UIView.animate(withDuration: animated ? 0.3 : 0.0,
                       animations: {
                        controller.view.alpha = 1.0
        },
                       completion: { (finished) in
                        controller.endAppearanceTransition()
                        controller.didMove(toParent: parrent)
        })
    }
    
    func removeChild(_ module: Presentable?, animated:Bool) {
        guard let controller = module?.toPresent() else { return }
        
        controller.willMove(toParent: nil)
        controller.beginAppearanceTransition(false, animated: true)
        
        UIView.animate(withDuration: animated ? 0.3 : 0.0,
                       animations: {
                        controller.view.alpha = 0.0
        },
                       completion: { (finished) in
                        controller.endAppearanceTransition()
                        controller.view.removeFromSuperview()
                        controller.removeFromParent()
        })
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}
