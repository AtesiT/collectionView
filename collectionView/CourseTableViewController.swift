import UIKit

class CourseTableViewController: UITableViewController {

    private var courses: [Course] = []
    
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
        URLSession.shared.dataTask(with: Link.datasUrl.url) { [weak self] data, _, error in
            guard let self else {return}
            guard let data else {
                print(error ?? "No error")
                return
            }
            
            do {
                //  После прохождения guard, в значении data хранится JSON-файл, который необходимо декодировать
                courses = try JSONDecoder().decode([Course].self, from: data)
                //  Нужно выйти в основной поток, чтобы отобразить что-либо на экране
                DispatchQueue.main.async {
                    //  Мы в двойном блоке замыкания. Здесь безопасно использовать self, т.к. он уже обработан выше
                    self.tableView.reloadData()
                }
                print(courses)
            } catch {
                print(error)
                //  Выведится не тот error, что выше(с сетью сязан), а другой (с декодипрованием связан)
            }

        }.resume()
    }
}
