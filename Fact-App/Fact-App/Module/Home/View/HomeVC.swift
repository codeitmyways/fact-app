//
//  HomeVC.swift
//  Fact-App
//
//  Created by Sumit meena on 20/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    let homeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        setupConstraints()
        // Do any additional setup after loading the view.
        setupBinding()
        homeViewModel.getFacts()

    }
    func setupBinding() {
      
        
        homeViewModel.facts.bind(to: tableView.rx.items(cellIdentifier: FactCell.identifier, cellType: FactCell.self)){ row,fact,cell in
            cell.fact = fact

        }.disposed(by: disposeBag)
        
        homeViewModel.title.subscribe { (title) in
            DispatchQueue.main.async {
                self.navigationItem.title = title
            }
        }.disposed(by: disposeBag)

    }

    private func setupConstraints(){
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(FactCell.self, forCellReuseIdentifier: FactCell.identifier)
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
