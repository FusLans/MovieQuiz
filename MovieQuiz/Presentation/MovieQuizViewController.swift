import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol{
    
    @IBOutlet weak private var counterLable: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var questionLable: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    // MARK: - Lifecycle
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        self.presenter.restartGame()
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        questionLable.text = step.question
        counterLable.text = step.questionNumber
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {[weak self] in guard let self = self else { return }
            self.changeButtonState(isEnable: true)
        }
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let resultModel = AlertModel(title: "Этот раунд окончен!", message: message, buttonText: "Сыграть ещё раз", completion:{
            self.presenter.restartGame()
        })
        
        alertPresenter.present(with: resultModel)
    }
    func changeButtonState(isEnable:Bool){
        noButton.isEnabled = isEnable
        yesButton.isEnabled = isEnable
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false 
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    private lazy var alertPresenter: AlertPresenter = AlertPresenter(controller: self)
    func showNetworkError(message: String){
            hideLoadingIndicator()
            
            let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз", completion: {[weak self] in guard let self = self else {return}
                presenter.restartGame()
                showLoadingIndicator()
            })
        
            alertPresenter.present(with: model)
        }
}
