import UIKit

class AlertPresenter {
    
    private let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func present(with alertData: AlertModel) {
        
        let alertController = UIAlertController(
            title: alertData.title,
            message: alertData.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertData.buttonText, style: .default) { _ in
            alertData.completion()
        }
        
        alertController.addAction(action)
        
        controller.present(alertController, animated: true)
    }
}
