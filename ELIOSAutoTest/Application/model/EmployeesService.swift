//
//  EmployeesService.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 07.01.2023.
//

import UIKit

// MARK: - Employee
struct Employee: Codable {
    let id: String
    let employeeName: String
    let employeeSalary: String
    let employeeAge: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case employeeName = "employee_name"
        case employeeSalary = "employee_salary"
        case employeeAge = "employee_age"
    }
}

class NetworkManager {
    func sendRequest(path: String, duplicate: Bool) {
        // -> String or error
    }
}

class EmployeesManager: UpdatableDataProvider, Codable {
    
    static var shared = EmployeesManager()
    private var employees: [Employee]?
    
    func getEmployees() -> [Employee] {
        
        if self.employees == nil {
            self.loadEmployees()
            self.loadEmployees()
            self.loadEmployees()
//            return self.employees ?? []
        }
        return self.employees ?? []
    }
    
    func loadEmployees() {
        ATRequestHelper.shared.requestGet(url: "https://raw.githubusercontent.com/johncodeos-blog/MVVMiOSExample/main/demo.json", params: ["": ""], contentType: .application_json, target: self) { request in // // к чему он относится?
            DispatchQueue.main.async {
                if let data = request.getData() {
                    do {
                        print("loadEmployees response")
                        let employees = try JSONDecoder().decode([Employee].self, from: data)
                        EmployeesManager.shared.employees = employees
                        EmployeesManager.shared.sendDataChangedEvent()
                        
                    } catch {
                        print(request.getError())
                    }
                }
            }
        }
    }
}

extension EmployeesManager: ELAutotestModelObject {
    
    static func getStateModelJson() -> String? {
        return shared.toJson()
    }
    static func loadStateStateObject(json: String?) {
        self.shared = EmployeesManager.loadFromJson(json: json) ?? EmployeesManager()
    }
}
