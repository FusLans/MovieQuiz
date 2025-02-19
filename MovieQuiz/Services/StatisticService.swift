import Foundation


final class StatisticService {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case total
    }
}

extension StatisticService: StatisticServiceProtocol {
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            guard let data = storage.data(forKey: Keys.bestGame.rawValue),
                  let result = try? JSONDecoder().decode(GameResult.self, from: data)
            else { return GameResult(correct: 0, total: 0, date: Date()) }
            
            return result
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            storage.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            if gamesCount == 0 { return 0 }
            else { return Double(correctAnswers) / (10 * Double(gamesCount)) * 100 }
        }
    }
    
    func store(correct: Int, total amount: Int) {
        
        gamesCount += 1
        correctAnswers += correct
        
        let result: GameResult = GameResult(correct: correct, total: amount, date: Date())
        
        if result.isBetterThan(bestGame) {
            bestGame = result
        }
    }
    
        
    
}
