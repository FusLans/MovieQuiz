import UIKit

final class MovieQuizPresenter {
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var currentQuestionIndex = 0
    let questionsAmount: Int = 10
    var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    func switchToNextQuestion (){
        currentQuestionIndex += 1
    }
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    @IBAction  func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    @IBAction  func noButtonClicked( ) {
        didAnswer(isYes: false)
        
    }
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = self.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            let text = correctAnswers == self.questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
            //            imageView.layer.borderColor = nil
            //            noButton.isEnabled = true
            //            yesButton.isEnabled = true
        }
        else {
            self.switchToNextQuestion()
            //            imageView.layer.borderColor = nil //убирает постоянное подсвечивание рамки при переключении вопросов
            questionFactory?.requestNextQuestion()
            //            imageView.layer.borderWidth = 0
            //            noButton.isEnabled = true
            //            yesButton.isEnabled = true
        }
    }
}
