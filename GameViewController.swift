import UIKit

class GameViewController: UIViewController {
    var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 5), count: 5)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialGrid()
    }

    func setupInitialGrid() {
        // Initialize grid with two random tiles
        addRandomTile()
        addRandomTile()
    }

    func addRandomTile() {
        var emptyPositions: [(Int, Int)] = []
        for row in 0..<5 {
            for col in 0..<5 {
                if grid[row][col] == 0 {
                    emptyPositions.append((row, col))
                }
            }
        }
        guard let randomPosition = emptyPositions.randomElement() else { return }
        grid[randomPosition.0][randomPosition.1] = 2 // Start with 2
    }

    // Implement swipe and merge logic here
}