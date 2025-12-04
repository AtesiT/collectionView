import UIKit

class CourseTableViewController: UITableViewController {

    private var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCourse", for: indexPath)
        guard let cell = cell as? CourseTableViewCell else { return UITableViewCell() }
        
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
                
                print(courses)
            } catch {
                print(error.localizedDescription)
                //  Выведится не тот error, что выше(с сетью сязан), а другой (с декодипрованием связан)
            }

        }.resume()
    }
}
