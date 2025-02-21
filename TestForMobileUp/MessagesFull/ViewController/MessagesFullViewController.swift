//
//  MessagesFullViewController.swift
//  TestForMobileUp
//
//  Created by Наджафов Араз on 30.10.2020.
//

import UIKit

class MessagesFullViewController: UIViewController {
    
    // - UI
    
    // Привязываем tableView к MessagesViewController
    @IBOutlet weak var tableView: UITableView!
    
    // Создаем Refresh Control типа UIRefreshControl
    var myRefreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }
    
    // Создаем Activity Indikator типа UIActivityIndicatorView
    var activityIndikator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // - URL
    
    // Создаем глобальную сессию
    private let session = URLSession.shared
    
    // Data
    private let url = URL(string: "https://s3-eu-west-1.amazonaws.com/builds.getmobileup.com/storage/MobileUp-Test/api.json")
    
    // - Model
    private var persons = [PersonModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Messages"
        
        configure()
        
        tableView.refreshControl = myRefreshControl
        
        activityIndikator.center = self.view.center
        activityIndikator.hidesWhenStopped = true
        activityIndikator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndikator)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CheckInternet.Connection(){
            print("Internet connected")
        } else {
            self.Alert(Message: "No internet connection")
        }
    }
    
    func Alert (Message: String) {
        let alert = UIAlertController(title: "Internet", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
}

// MARK: -
// MARK: - Date
extension DateFormatter {
    func date(fromSwapiString dateString: String) -> Date? {
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "en_US_POSIX")
        return self.date(from: dateString)
    }
}

extension String {
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func serverToLocal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

// MARK: -
// MARK: - imageURlString
public extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

// MARK: -
// MARK: - Configure TableView DataSource
extension MessagesFullViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesFullTableViewCell", for: indexPath) as! MessagesFullTableViewCell
        
        let imageURlString = persons[indexPath.row].user!.image
        if let url = URL(string: imageURlString) {
            cell.personImageView.load(url: url)
        } else {
            cell.personImageView.image = UIImage(named: "Default")
        }
        
        cell.personNameLabel.text = persons[indexPath.row].user!.name
        cell.messageLabel.text = persons[indexPath.row].message!.message
        cell.timeLabel.text = (persons[indexPath.row].message!.date.stringToDate()?.serverToLocal())! + "  >"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            persons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
}

// MARK: -
// MARK: - Configure TableView Delegate
extension MessagesFullViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}

// MARK: -
// MARK: - Server Request
// Функция, отвечающая за получение данных из сети
private extension MessagesFullViewController {
    
    // completionHandler - функция, которую мы "описали", но выполнится она только тогда, когда мы её вызовем, а вызовем мы её "изнутри" dataTask, то есть только тогда, когда к нам придет ответ с сервера; Closure - замыкание, анонимный блок кода, который выполняется в определенный момент времени; замыкаются данные, с которыми будут работать (data, response, error) и после in можно использовать, так как они замкнуты
    func getMessages() {
        let task = session.dataTask(with: url!, completionHandler: { [weak self] data, response, error in
            
            guard let strongSelf = self else {return}
            
            // Если закомментировать stopLoader(), то можно увидеть загружающийся индикатор
//            DispatchQueue.main.async {
//                strongSelf.stopLoader()
//            }
            
            if let error = error {
                
                let nothingFoundVC = UIStoryboard(name: "MessagesEmpty", bundle: nil).instantiateInitialViewController() as! MessagesEmptyViewController
                self?.navigationController?.pushViewController(nothingFoundVC, animated: true)
                
                // localizedDescription помогает получить "адекватную" ошибку в виде текста; то есть, если ошибка будет, то мы её выведем и выйдем из функции, чтобы дальше не продолжать
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // В response можно увидеть, какой у ответа статус-код, если ответ от 200 до 299, то ответ положительный, если ответ, например, 404, то ответ отрицательный
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                print("Ответ положительный: \(httpResponse.statusCode)")
                
                // Делаем декодирование и смотрим ответ с сервера
                guard let data = data else {return}
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print(json)
                }
                
                // Работаем с массивом persons, так как нам приходит в ответ массив от сервера; далее мы конвертируем в JSON, создаем обьект типа JSONDecoder, который декодируем в указанный тип - PersonModel.self и передаем туда data; после мы получаем обьекты (массив Personов) и присваиваю их persons
                self?.persons = try! JSONDecoder().decode([PersonModel].self, from: data)
                
                // Перезагружаем данные, так как изначально у нас в массиве persons - ноль обьектов, после они загружаются из JSON и обновляются; само обновление вкладвыается в closure DispatchQueue
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            
        })
        
        // Запрос серверу и выполнение функции
        task.resume()
        
    }
    
    // Если не обращаться к [weak self], то будет утечка памяти, так как наша функция замыкания - reference type (ссылочный тип), то есть обьект "живет", пока на неё есть хотя бы одна ссылка, в нашем случае ссылка от MessagesViewController, но completionHandler внутри себя использует self сильной ссылкой, то есть получается, что completionHandler указывает на MessagesViewController и в итоге эти 2 ссылки не уходят из памяти; значит, нужно одну ссылку сделать weak, а к self привязать ?, чтобы связь стала тоже weak
    
}


// MARK: -
// MARK: - Configure

private extension MessagesFullViewController {
    
    func configure() {
        configureTableView()
        setupNavigationBar()
        startLoader()
        getMessages()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

// MARK: -
// MARK: - Activity Indikator

private extension MessagesFullViewController {
    
    func startLoader() {
        activityIndikator.startAnimating()
    }
    
    func stopLoader() {
        activityIndikator.stopAnimating()
    }
    
}
