import UIKit

class GameViewController: UIViewController {
    var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 5), count: 5)
    var gridViews: [[UILabel]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInitialGrid()
        refreshGrid()
        
        // Add Swipe Gestures
        setupSwipeGestures()
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

    func setupSwipeGestures() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            swipeGesture.direction = direction
            view.addGestureRecognizer(swipeGesture)
        }
    }

    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            handleSwipe(at: .up)
        case .down:
            handleSwipe(at: .down)
        case .left:
            handleSwipe(at: .left)
        case .right:
            handleSwipe(at: .right)
        default:
            break
        }
    }

    func handleSwipe(at direction: UISwipeGestureRecognizer.Direction) {
        var moved = false

        switch direction {
        case .up:
            for col in 0..<5 {
                var column = [Int]()
                for row in 0..<5 { column.append(grid[row][col]) }
                let mergedColumn = mergeTiles(column)
                for row in 0..<5 { 
                    if grid[row][col] != mergedColumn[row] { moved = true }
                    grid[row][col] = mergedColumn[row] 
                }
            }
        case .down:
            for col in 0..<5 {
                var column = [Int]()
                for row in (0..<5).reversed() { column.append(grid[row][col]) }
                let mergedColumn = mergeTiles(column)
                for (k, row) in (0..<5).reversed().enumerated() {
                    if grid[row][col] != mergedColumn[k] { moved = true }
                    grid[row][col] = mergedColumn[k] 
                }
            }
        case .left:
            for row in 0..<5 {
                let mergedRow = mergeTiles(grid[row])
                if grid[row] != mergedRow { moved = true }
                grid[row] = mergedRow
            }
        case .right:
            for row in 0..<5 {
                let reversedRow = grid[row].reversed()
                let mergedRow = mergeTiles(Array(reversedRow))
                for (i, value) in mergedRow.reversed().enumerated() {
                    if grid[row][i] != value { moved = true }
                    grid[row][i] = value
                }
            }
        default:
            break
        }

        if moved {
            addRandomTile()
            refreshGrid()
        }
    }

    func mergeTiles(_ tiles: [Int]) -> [Int] {
        var filteredTiles = tiles.filter { $0 > 0 }
        var mergedTiles: [Int] = []

        var i = 0
        while i < filteredTiles.count {
            if i < filteredTiles.count - 1, filteredTiles[i] == filteredTiles[i + 1] {
                mergedTiles.append(filteredTiles[i] * 2)
                i += 2
            } else {
                mergedTiles.append(filteredTiles[i])
                i += 1
            }
        }

        // Fill remaining spaces with zeros
        while mergedTiles.count < 5 {
            mergedTiles.append(0)
        }

        return mergedTiles
    }
}