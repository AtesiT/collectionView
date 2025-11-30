import UIKit

enum СountOfCellsWithSmth: CaseIterable {
    case phone
    case email
    
    var title: String {
        switch self {
        case .phone: return "Phone"
        case .email: return "Email"
        }
    }
}

final class CollectionViewController: UICollectionViewController {
    
    private let allCells = СountOfCellsWithSmth.allCases // At first we make an array
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCells.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let cell = cell as? CollectionViewCell else {return UICollectionViewCell()}
        cell.label.text = allCells[indexPath.item].title
        
        return cell
    }
}
