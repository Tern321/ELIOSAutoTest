//
//  ServiceLocator.swift
//  ELIOSAutoTest
//
//  Created by jack on 28.12.2023.
//

import UIKit

class ServiceLocator: NSObject {
    func locatorForContainer(container: ServiceContainer) -> ServiceLocator? {
        return nil
    }
}

class ServiceContainer: NSObject { // все контейнеры сервисов наследуются от этого обьекта
}

class ServiceObject: NSObject { // все сервисы наследуются от этого обьекта
    
}
