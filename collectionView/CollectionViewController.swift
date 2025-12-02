import UIKit

enum СountOfCellsWithSmth: CaseIterable {
    case phone
    case email
    case fetchData
    case fetchDatas
    case course
    
    var title: String {
        switch self {
        case .phone: return "Phone"
        case .email: return "Email"
        case .fetchData: return "Fetch Data"
        case .fetchDatas: return "Fetch Datas"
        case .course: return "Course"
        }
    }
}

enum Link {
    case phoneUrl
    case emailUrl
    case dataUrl
    case datasUrl
    
    var url: URL {
        switch self {
        case .phoneUrl: return URL(string: "https://m.media-amazon.com/images/I/41dMrsctqEL._SS64_.jpg")!
        case .emailUrl: return URL(string: "https://m.media-amazon.com/images/I/41IkY62ngPL._SS64_.jpg")!
        case .dataUrl: return URL(string: "")! // None URL
        case .datasUrl: return URL(string: "")! // None URL
        }
    }
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success: return "Success"
        case .failed: return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success: return "Data fetched successfully"
        case .failed: return "Failed to fetch data"
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
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.message, message: status.title, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        //  Мы используем наш showAlert в блоке замыкания и поэтому надо асинхронно вернуться в основной поток
        //  Вернуться надо по той причине, что надо отобразить Alert(элемент интерфейса), а значит нужно вернуться в main thread
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)}
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
            fetchData()
        case .fetchDatas:
            fetchDatas()
        case .course:
            print("")
        }
    }
}

extension CollectionViewController {
    private func fetchData() {
        URLSession.shared.dataTask(with: Link.dataUrl.url) { [weak self] data, _, error in
            guard let self else {return}
            guard let data else {
                print(error?.localizedDescription ?? "No error")
                return
            }
            do {
                //  После прохождения guard, в значении data хранится JSON-файл, который необходимо декодировать
                let course = try JSONDecoder().decode(Course.self, from: data)
                print(course)
                showAlert(withStatus: .success)
            } catch {
                print(error.localizedDescription)
                //  Выведится не тот error, что выше(с сетью сязан), а другой (с декодипрованием связан)
                showAlert(withStatus: .failed)
            }

        }.resume()
    }
    private func fetchDatas() {
        URLSession.shared.dataTask(with: Link.phoneUrl.url) { [weak self] data, _, error in
            guard let self else {return}
            guard let data else {
                print(error?.localizedDescription ?? "No error")
                return
            }
            do {
                //  После прохождения guard, в значении data хранится JSON-файл, который необходимо декодировать
                let course = try JSONDecoder().decode([Course].self, from: data)
                print(course)
                showAlert(withStatus: .success)
            } catch {
                print(error.localizedDescription)
                //  Выведится не тот error, что выше(с сетью сязан), а другой (с декодипрованием связан)
                showAlert(withStatus: .failed)
            }

        }.resume()
    }
}
