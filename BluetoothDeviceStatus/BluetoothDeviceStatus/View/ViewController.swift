//
//  ViewController.swift
//  BluetoothDeviceStatus
//
//  Created by Ankit on 16/12/21.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    private let viewModel = BluetoothDeviceViewModel()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(view: tableView, edges: .zero)
        viewModel.startScan { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfDevices
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.titleFor(row: indexPath.row)
        return cell
    }
}

extension UIView {
    func addSubview(view: UIView, edges: UIEdgeInsets = .zero) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: edges.left),
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: edges.right),
            view.topAnchor.constraint(equalTo: topAnchor, constant: edges.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: edges.bottom)
        ])
    }
    
}
