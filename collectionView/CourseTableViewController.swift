import UIKit

class CourseTableViewController: UITableViewController {

    private var courses: [Course] = []
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VC is ready!")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCourse", for: indexPath)
        guard let cell = cell as? CourseTableViewCell else { return UITableViewCell() }
        let course = courses[indexPath.row]
        cell.configure(with: course)
        
        
        return cell
    }
    func takeCourses() {
        networkManager.fetch([Course].self, from: Link.datasUrl.url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let courses):
                self.courses = courses
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
