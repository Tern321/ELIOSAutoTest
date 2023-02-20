import Foundation
import SwiftSignalRClient

protocol AutotestTransportServiceProtocol {
    func sendRunTestCaseResponse(testInfo: TestScreenData)
}

protocol AutotestTransportServiceDelegate: AnyObject {
    func runTestCase(testInfo: TestScreenData)
    func collectTestData( testInfo: TestScreenData) -> TestScreenData
}

class SignalRService: AutotestTransportServiceProtocol {
    private var connection: HubConnection
    
    weak var delegate: AutotestTransportServiceDelegate?
    
    func sendRunTestCaseResponse(testInfo: TestScreenData) {
        self.connection.send(method: "runTestCaseResponse", testInfo)
    }
    
    func sendGetTestDataResponse(testInfo: TestScreenData) {
        self.connection.send(method: "getTestDataResponse", testInfo)
    }
    
    public init(url: URL) {
        connection = HubConnectionBuilder(url: url).withLogging(minLogLevel: .error).build()
        connection.delegate = self
        
        connection.on(method: "runTestCaseRequest", callback: { (testInfo: TestScreenData) in
            self.delegate?.runTestCase(testInfo: testInfo)
        })
        
        connection.on(method: "getTestDataRequest", callback: { (testInfo: TestScreenData) in
            if let testInfo = self.delegate?.collectTestData(testInfo: testInfo) {
                self.sendGetTestDataResponse(testInfo: testInfo)
            }
        })
        
        connection.on(method: "Connected", callback: { (user: String) in
            print(user)
        })
        connection.start()
    }
}
extension SignalRService: HubConnectionDelegate {
    
    func updateDeviceName() {
        self.connection.send(method: "updateDeviceName", "ios_forum_client_1")
    }
    
    public func connectionDidOpen(hubConnection: HubConnection) {
        print("connectionDidOpen")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.updateDeviceName()
        }
    }

    public func connectionDidReconnect() {
        print("connectionDidReconnect")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.updateDeviceName()
        }
    }
    
    public func connectionDidFailToOpen(error: Error) {}
    public func connectionDidClose(error: Error?) {}
    public func connectionWillReconnect(error: Error) {}
}
