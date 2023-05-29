//
//  EmployeeCell.swift
//  MVVMExample
//
//  Created by John Codeos on 06/19/20.
//

import UIKit

protocol EmployeeCellDelegate: AnyObject {
    func actionA(employee: Employee, indexPath: IndexPath)
    func actionB(employee: Employee, indexPath: IndexPath)
}

class EmployeeCell: UITableViewCell {
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var salaryLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!

    weak var delegate: EmployeeCellDelegate?
    var indexPath: IndexPath?
    var employee: Employee?
    
    func setup(employee: Employee, indexPath: IndexPath, delegate: EmployeeCellDelegate) {
        idLabel.text = employee.id
        nameLabel.text = employee.employeeName
        salaryLabel.text = employee.employeeSalary
        ageLabel.text = employee.employeeAge
        
        self.indexPath = indexPath
        self.delegate = delegate
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    func initView() {
        backgroundColor = .clear
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        idLabel.text = nil
        nameLabel.text = nil
        salaryLabel.text = nil
        ageLabel.text = nil
    }
}
