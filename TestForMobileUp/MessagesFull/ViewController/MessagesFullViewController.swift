//
//  MessagesFullViewController.swift
//  TestForMobileUp
//
//  Created by Наджафов Араз on 30.10.2020.
//

import UIKit

class MessagesFullViewController: UIViewController {

    // - UI
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
    }

}

// MARK: -
// MARK: - Configure TableView DataSource
extension MessagesFullViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

// MARK: -
// MARK: - Configure TableView Delegate
extension MessagesFullViewController: UITableViewDelegate {
    
}

// MARK: -
// MARK: - Configure

private extension MessagesFullViewController {
    
    func configure() {
        configureTableView()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}
