//
//  MessagesEmptyViewController.swift
//  TestForMobileUp
//
//  Created by Наджафов Араз on 30.10.2020.
//

import UIKit

class MessagesEmptyViewController: UIViewController {

    // - UI
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
    }

}

// MARK: -
// MARK: - Configure TableView DataSource
extension MessagesEmptyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}

// MARK: -
// MARK: - Configure TableView Delegate
extension MessagesEmptyViewController: UITableViewDelegate {
    
}

// MARK: -
// MARK: - Configure

private extension MessagesEmptyViewController {
    
    func configure() {
        configureTableView()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}
