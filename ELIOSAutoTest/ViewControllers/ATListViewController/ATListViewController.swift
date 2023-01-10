//
//  ATListViewController.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 07.01.2023.
//

import UIKit

extension ATListViewController: EmployeeCellDelegate {
    
    func actionA(employee: Employee, indexPath: IndexPath) {
        print("actionA")
    }
    
    func actionB(employee: Employee, indexPath: IndexPath) {
        print("actionB")
    }
}

extension ATListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithType(EmployeeCell.self)
        cell.setup(employee: self.model.employers[indexPath.row], indexPath: indexPath, delegate: self)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.employers.count ?? 0
    }
}

class ATListViewController: UIViewController, WMDataUpdatable {

    var model: ATListViewControllerModel!
    @IBOutlet var table: UITableView!
    
    func onDataChanged() { // change to custom method
        refillModel()
    }
    
    func refillModel() {
        DispatchQueue.main.async {
            
            self.model?.employers = EmployeesManager.shared.getEmployees()
            print(self.model?.employers)
            
            self.table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmployeesManager.shared.addDelegate(delegate: self)
        refillModel()
    }

}
