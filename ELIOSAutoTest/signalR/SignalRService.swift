import Foundation
import SwiftSignalRClient

class TestData : Codable {
    var user: String?
    var string1: String?
    var string2: String?
}

public class SignalRService {
    private var connection: HubConnection
    
    public init(url: URL) {
        connection = HubConnectionBuilder(url: url).withLogging(minLogLevel: .error).build()
        //        connection.
        
        connection.on(method: "MessageReceived", callback: { (user: String, message: String) in
            do {
                self.handleMessage(message, from: user)
            } catch {
                print(error)
            }
        })
        connection.on(method: "SendDataMessage", callback: { (data: TestData) in
            do {
                print("got SendDataMessage \(data.user) \(data.string1) \(data.string2)")
                //                self.handleMessage(message, from: user)
            } catch {
                print(error)
            }
        })
        
        connection.on(method: "ShowTime", callback: { (user: String, message: String) in
            do {
                self.handleMessage(message, from: user)
            } catch {
                print(error)
            }
        })
        
        connection.on(method: "Connected", callback: { (user: String) in
            //            do {
            ////                self.handleMessage(message, from: user)
            //            } catch {
            print(user)
            //            }
        })
        connection.start()
        
        sendTest()
        
    }
    
    private func handleMessage(_ message: String, from user: String) {
        // Do something with the message.
        print(user)
        print(message)
        
    }
    func sendTest() {
        print("sendTest\(connection.connectionId)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.connection.send(method: "MyMethod", "test")
            self.connection.invoke(method: "MyMethod", "test", resultType: String.self) { result, error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("Add result: \(result!)")
                }
            }
//            self.connection.invoke(method: "TestFromClient", "2", "3", resultType: String.self) { result, error in
//                if let error = error {
//                    print("error: \(error)")
//                } else {
//                    print("Add result: \(result!)")
//                }
//            }
        }
        
        
        //        connection.send(method: "ios", "test")
        //        connection.send(method: "ios test")
    }
}
