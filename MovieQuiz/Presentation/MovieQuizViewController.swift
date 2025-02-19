import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate{
    @IBOutlet weak private var counterLable: UILabel!
    @IBOutlet weak private var questionLable: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    // MARK: - Lifecycle
    override  func viewDidLoad() {
        super.viewDidLoad()
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
               return
           }
           currentQuestion = question
           let viewModel = convert(model: question)
           
           DispatchQueue.main.async { [weak self] in
               self?.show(quiz: viewModel)
           }
    }
    private let statisticService:StatisticService = StatisticService()
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let stepQuestion = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return stepQuestion
    }
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLable.text = step.question
        counterLable.text = step.questionNumber
    }
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        noButton.isEnabled = false
        yesButton.isEnabled = false
        if isCorrect{
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        }
        else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
        
    }
        
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let resultText = "\nКоличество квизов: \(statisticService.gamesCount)\n" +
            "Лучший результат: \(statisticService.bestGame.correct) (\(statisticService.bestGame.date.dateTimeString))\n" +
            "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel( // 2
                title: "Этот раунд окончен!",
                text: text + resultText,
                buttonText: "Сыграть ещё раз")
            imageView.layer.borderColor = nil
            noButton.isEnabled = true
            yesButton.isEnabled = true
            show(quiz: viewModel)
        }
        else {
            currentQuestionIndex += 1
            imageView.layer.borderColor = nil //убирает постоянное подсвечивание рамки при переключении вопросов
            questionFactory.requestNextQuestion()
            imageView.layer.borderWidth = 0
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        AlertPresenter(controller: self).present(with:
            AlertModel(title: result.title,
                       message: result.text,
                       buttonText: result.buttonText,
                       completion: { [weak self] in
                            guard let self = self else { return }
                            self.currentQuestionIndex = 0
                            self.correctAnswers = 0
                            questionFactory.requestNextQuestion()
                        }))
    }
}




/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
