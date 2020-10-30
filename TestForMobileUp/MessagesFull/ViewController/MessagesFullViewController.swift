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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
        tableView.refreshControl = myRefreshControl
        
        activityIndikator.center = self.view.center
        activityIndikator.hidesWhenStopped = true
        activityIndikator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndikator)
        
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }

}

// MARK: -
// MARK: - Configure TableView DataSource
extension MessagesFullViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesFullTableViewCell", for: indexPath) as! MessagesFullTableViewCell
        
        return cell
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
// MARK: - Configure

private extension MessagesFullViewController {
    
    func configure() {
        configureTableView()
        startLoader()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
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
