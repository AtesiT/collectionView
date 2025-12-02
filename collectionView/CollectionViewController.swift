import UIKit

enum СountOfCellsWithSmth: CaseIterable {
    case phone
    case email
    case fetchData
    
    var title: String {
        switch self {
        case .phone: return "Phone"
        case .email: return "Email"
        case .fetchData: return "Fetch Data"
        }
    }
}

enum Link {
    case phoneUrl
    case emailUrl
    
    var url: URL {
        switch self {
        case .phoneUrl: return URL(string: "https://m.media-amazon.com/images/I/41dMrsctqEL._SS64_.jpg")!
        case .emailUrl: return URL(string: "https://m.media-amazon.com/images/I/41IkY62ngPL._SS64_.jpg")!
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

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    //  Данный метод возвращает размеры ячейки
    //  CG - хранит данные о работе с графикой(числовые типа интерфейса)
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 50 , height: 100)
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //  Метод, благодаря которому, можно отследить по какой ячейки нажимает пользователь
        let userAction = allCells[indexPath.item]
        
        switch userAction {
        case .phone:
            performSegue(withIdentifier: "phoneSegue", sender: nil)
        case .email:
            performSegue(withIdentifier: "emailSegue", sender: nil)
        case .fetchData:
            print("")
        }
    }
}

extension CollectionViewController {
    private func fetchData() {
        
    }
}
