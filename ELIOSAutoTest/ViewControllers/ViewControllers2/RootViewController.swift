//
//  RootViewController.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 14.07.2022.
//

import UIKit
import MediaPlayer
import AudioToolbox

class RootViewController: ELTestableViewController {

    @IBOutlet var modelStateLabel: UILabel!
    @IBOutlet var viewControllerStateLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var robotPicture: UIImageView!
    
    @objc dynamic var name: String?
    
    static var shared: RootViewController?
    var testObjcObj = ObjcTestClass()

    override func getModelJson() -> String? {
        return "{}"
    }
    override func loadModelJson(json: String) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RootViewController.shared = self
        self.robotPicture.image = Asset.robot.image
//        print(EmployeesManager.self.getStateModelJson())
//        (myClasses[0].self as? ELAutotestModelObject.Type).Type.getStateModelJson()
//        var json = (myClasses[0] as? ELAutotestModelObject).getStateModelJson()
//        print(json)
        
//        self.textField.observe(\.text, options: .new) { person, change in
//            print("I'm now called \(person.text)")
//        }
        
//        var testedViewControllerClass = NSClassFromString("ELIOSAutoTest.SecondViewController")
        
//        self.bind(NSBindingName(rawValue: #keyPath(self.textField.text)), to: firstCounter, withKeyPath: #keyPath(self.name), options: nil)
        
//        secondCounter.bind(NSBindingName(rawValue: #keyPath(Counter.number)), to: firstCounter, withKeyPath: #keyPath(Counter.number), options: nil)

//        textField.text
//        let person: Person
//        let nameLabel: UILabel

//        name.bindTo
//        textField.rValueForKeyPath("firstName").bindTo(nameLabel)
        
//        textField.bind
//        textField.bind(NSHiddenBinding,
//                             to: self,
//                             withKeyPath: #keyPath(enabledCheckbox),
//                             options: [NSValueTransformerNameBindingOption: NSValueTransformerName.negateBooleanTransformerName])
        
    }
    
    @IBAction func secondVk() {
        self.navigationController?.pushViewController(SecondViewController.loadViewControllerFromXib(), animated: false)
    }
    
    @IBAction func test() {
        let nextVK = ATListViewController.loadViewControllerFromXib()
        nextVK.model = ATListViewControllerModel()
        self.navigationController?.pushViewController(nextVK, animated: false)
    }
    func showData() {
//        var a = UIApplication.shared.windows.count
//        print(a)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
