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

    let tableView : UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        self.view.addSubview(tableView)
        setupConstraints()
        // Do any additional setup after loading the view.
        setupBinding()
        homeViewModel.getFacts()

    }
    func setupBinding() {
        tableView.register(UINib(nibName: FactCell.identifier, bundle: nil), forCellReuseIdentifier: String(describing: FactCell.self))
        
        homeViewModel.facts.bind(to: tableView.rx.items(cellIdentifier: FactCell.identifier, cellType: FactCell.self)){ row,fact,cell in
            cell.fact = fact

        }.disposed(by: disposeBag)

    }

    private func setupConstraints(){
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true

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
