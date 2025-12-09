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
        case .dataUrl: return URL(string: "https://microsoftedge.github.io/Demos/json-dummy-data/64KB.json")!
        case .datasUrl: return URL(string: "https://microsoftedge.github.io/Demos/json-dummy-data/64KB.json")!
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
    private let networkManager = NetworkManager.shared
    
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
    
    // MARK: - UICollectionViewDelegate
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
            performSegue(withIdentifier: "cellCourseVC", sender: nil)
        }
    }
    //  MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "phoneSegue" {
            let phoneVC = segue.destination as? PhoneViewController
        } else if segue.identifier == "emailSegue" {
            let emailVC = segue.destination as? EmailViewController
        } else if segue.identifier == "cellCourseVC" {
            let courseVC = segue.destination as? CourseTableViewController
            courseVC?.takeCourses()
        }
    }
}

extension CollectionViewController {
    private func fetchData() {
        networkManager.fetch(Course.self, from: Link.dataUrl.url) { result in
            switch result {
            case .success(let course):
                print(course)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchDatas() {
        networkManager.fetch([Course].self, from: Link.datasUrl.url) { result in
            switch result {
            case .success(let courses):
                print(courses)
            case .failure(let error):
                print(error)
            }
        }
    }
    private func postRequestDictionary() {
        let parameters = [
            "name": "Networking",
            "imageUrl": "https://example.com/image.png",
            "numberOfLessons": "10",
            "numberOfTests": "5"
        ]
        
        networkManager.postRequest(with: parameters, to: Link.datasUrl.url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let json):
                print(json)
                showAlert(withStatus: .success)
            case .failure(let error):
                print(error)
                showAlert(withStatus: .failed)
            }
        }
    }
    private func postRequestModel() {
        let course = [
            "name": "Networking",
            "imageUrl": "https://example.com/image.png",
            "numberOfLessons": "10",
            "numberOfTests": "5"
        ]
        
        networkManager.postRequest(with: course, to: Link.dataUrl.url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let json):
                print(json)
                showAlert(withStatus: .success)
            case .failure(let error):
                print(error)
                showAlert(withStatus: .failed)
            }
        }

    }
}
