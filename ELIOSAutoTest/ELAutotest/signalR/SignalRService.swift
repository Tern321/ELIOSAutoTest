import Foundation
import SwiftSignalRClient

protocol AutotestTransportServiceProtocol {
    func sendRunTestCaseResponse(_ testInfo: TestCaseData)
}

protocol AutotestTransportServiceDelegate: AnyObject {
    func runTestCase(_ testInfo: ELTestRun)
    func collectTestData(_ testInfo: TestCaseData) -> TestCaseData
    
    func startRecording(_ testInfo: TestCaseData)
    func addRecordingScreenshot()
    func endRecording() -> TestCaseData
//    func runEventResponse() -> TestRunEventResult
}

public class ForeverReconnectPolicy: ReconnectPolicy {
    public init() {
    }

    public func nextAttemptInterval(retryContext: RetryContext) -> DispatchTimeInterval {
        return .seconds(2)
    }
}

class SignalRService: AutotestTransportServiceProtocol {
    static var deviceId = "ios_forum_client_1"
    private var connection: HubConnection
    
    weak var delegate: AutotestTransportServiceDelegate?
    
    func sendRunTestCaseResponse(_ testInfo: TestCaseData) {
        self.connection.send(method: "runTestCaseResponse", testInfo)
    }
    
    func sendGetTestDataResponse(_ testInfo: TestCaseData) {
        self.connection.send(method: "getTestDataResponse", testInfo)
    }
    
//    func sendRecordActionsResponse(_ testInfo: AutotestSetupData) {
//        self.connection.send(method: "endRecordingResponse", testInfo)
//    }
//
    func endRecordingResponse(_ testInfo: TestCaseData) {
        self.connection.send(method: "endRecordingResponse", testInfo)
    }
    
    func testRunEventResponse(_ eventResult: TestRunEventResult) {
        self.connection.send(method: "testRunEventResponse", eventResult)
    }
    
    public init(url: URL) {
        
        connection = HubConnectionBuilder(url: url).withLogging(minLogLevel: .error).withAutoReconnect(reconnectPolicy: ForeverReconnectPolicy()).build()
        connection.delegate = self
        
//        connection.on(method: "connectionDidClose", callback: { (testInfo: TestCaseData) in
//            print("connectionDidClose")
////            connection.handshakeStatus.isReconnect
//        })
        
        connection.on(method: "runTestCaseRequest", callback: { (testInfo: ELTestRun) in
            self.delegate?.runTestCase(testInfo)
        })
        
        connection.on(method: "getTestDataRequest", callback: { (testInfo: TestCaseData) in
            if let testInfo = self.delegate?.collectTestData(testInfo) {
                self.sendGetTestDataResponse(testInfo)
            }
        })
        
        connection.on(method: "startRecording", callback: { (testInfo: TestCaseData) in
            print("startRecording")
            self.delegate?.startRecording(testInfo)
        })
        connection.on(method: "addRecordingScreenshot", callback: {
            print("addRecordingScreenshot")
            self.delegate?.addRecordingScreenshot()
        })
        connection.on(method: "endRecording", callback: {
            if let testData = self.delegate?.endRecording() {
                var json = testData.toJson()
                print(json)
                self.endRecordingResponse(testData)
            }
            
        })
//        connection.on(method: :", callback: <#T##(ArgumentExtractor) throws -> Void##(ArgumentExtractor) throws -> Void##(_ argumentExtractor: ArgumentExtractor) throws -> Void#>)
        connection.on(method: "Connected", callback: { (user: String) in
            print(user)
        })
        connection.start()
    }
}
extension SignalRService: HubConnectionDelegate {
    
    func updateDeviceName() {
        self.connection.send(method: "updateDeviceName", SignalRService.deviceId)
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
