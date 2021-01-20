//
//  HomeVC.swift
//  Fact-App
//
//  Created by Sumit meena on 20/01/21.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")

        // Do any additional setup after loading the view.
        APIRequestFact().dispatch { (success) in
            print(success)
        } onFailure: { (errorResponse, error) in
            if let errorMsg  = (errorResponse?.message ?? error.localizedDescription) {
//                self.error.onNext(errorMsg)
                print(errorMsg)
            }
        }

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
