import Observation

enum Team {
    case home, guest
}

@Observable
final class ScoreModel {
    var homeName = "Home"
    var guestName = "Guest"
    private(set) var homeScore = 0
    private(set) var guestScore = 0
    private(set) var history: [(team: Team, points: Int)] = []

    func add(_ points: Int, to team: Team) {
        switch team {
        case .home: homeScore += points
        case .guest: guestScore += points
        }
        history.append((team, points))
    }

    func undo() {
        guard let last = history.popLast() else { return }
        switch last.team {
        case .home: homeScore -= last.points
        case .guest: guestScore -= last.points
        }
    }

    /// Short description of what the next undo removes, e.g. "Home +2".
    var lastActionLabel: String? {
        guard let last = history.last else { return nil }
        let name = last.team == .home ? homeName : guestName
        return "\(name) +\(last.points)"
    }
}
