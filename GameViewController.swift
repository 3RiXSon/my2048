import UIKit

class GameViewController: UIViewController {
    var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 5), count: 5)
    var gridViews: [[UILabel]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInitialGrid()
        refreshGrid()
    }

    func setupUI() {
        view.backgroundColor = .white
        let gridSize: CGFloat = min(view.frame.width, view.frame.height) - 40
        let tileSize = gridSize / 5
        
        let gridContainer = UIView(frame: CGRect(x: 20, y: (view.frame.height - gridSize) / 2, width: gridSize, height: gridSize))
        gridContainer.backgroundColor = .lightGray
        gridContainer.layer.cornerRadius = 8
        view.addSubview(gridContainer)

        for row in 0..<5 {
            var rowViews: [UILabel] = []
            for col in 0..<5 {
                let tile = UILabel(frame: CGRect(x: tileSize * CGFloat(col), y: tileSize * CGFloat(row), width: tileSize - 8, height: tileSize - 8))
                tile.backgroundColor = .white
                tile.textAlignment = .center
                tile.font = UIFont.boldSystemFont(ofSize: 24)
                tile.layer.cornerRadius = 4
                tile.clipsToBounds = true
                gridContainer.addSubview(tile)
                rowViews.append(tile)
            }
            gridViews.append(rowViews)
        }
    }

    func setupInitialGrid() {
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
        grid[randomPosition.0][randomPosition.1] = Int.random(in: 1...2) * 2
    }

    func refreshGrid() {
        for row in 0..<5 {
            for col in 0..<5 {
                let value = grid[row][col]
                let tile = gridViews[row][col]
                tile.text = value == 0 ? "" : "\(value)"
                tile.backgroundColor = value == 0 ? .white : (value == 2 ? .orange : .red)
            }
        }
    }
}