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


protocol EmployeesServiceProtocol {
    func getEmployees(completion: @escaping (_ success: Bool, _ results: [Employee]?, _ error: String?) -> Void)
}

class NetworkManager {
    func sendRequest(path: String, duplicate: Bool) {
        // -> String or error
    }
}

class EmployeesManager: WMUpdatableDataProvider, Codable {
    
    static var shared = EmployeesManager()
    private var employees: [Employee]?

    func getEmployees() -> [Employee] {
        
        if self.employees == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadEmployees { success, employees2, error in
                    self.sendDataChangedEvent()
                    self.employees = employees2 ?? []
                    print("getEmployees update")
                }
            }
        }
        return self.employees ?? []
    }
    
    func loadEmployees(completion: @escaping (Bool, [Employee]?, String?) -> Void) {
        HttpRequestHelper().GET(url: "https://raw.githubusercontent.com/johncodeos-blog/MVVMiOSExample/main/demo.json", params: ["": ""], httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode([Employee].self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Employees to model")
                }
            } else {
                completion(false, nil, "Error: Employees GET Request failed")
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

class EmployeesService: EmployeesServiceProtocol {
    
    func getEmployees(completion: @escaping (Bool, [Employee]?, String?) -> Void) {
        HttpRequestHelper().GET(url: "https://raw.githubusercontent.com/johncodeos-blog/MVVMiOSExample/main/demo.json", params: ["": ""], httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode([Employee].self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Employees to model")
                }
            } else {
                completion(false, nil, "Error: Employees GET Request failed")
            }
        }
    }
}
