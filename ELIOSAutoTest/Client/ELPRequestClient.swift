//
//  ELPRequestClient.swift
//  SocketClient
//
//  Created by EVGENII Loshchenko on 11.07.2022.
//

import UIKit

extension Data {
    init(reading input: InputStream) throws {
        self.init()
        input.open()
        defer {
            input.close()
        }
        
        let bufferSize = 1024 * 1024 * 2
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer {
            buffer.deallocate()
        }
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if read < 0 {
                throw input.streamError!
            } else if read == 0 {
                break
            }
            self.append(buffer, count: read)
        }
    }
}

extension Data {
    init(reading2 input: InputStream) {
            self.init()
            
            let bufferSize = 1024 * 1024
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            while input.hasBytesAvailable {
                let read = input.read(buffer, maxLength: bufferSize)
                self.append(buffer, count: read)
            }
            buffer.deallocate()
        }
}

class ELPRequestClient: NSObject, StreamDelegate {
    var inputStream: InputStream!
    var outputStream: OutputStream!
    weak var messageManager: ELPRequestClientMessageManager!
    
    var readStream: Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if aStream == inputStream {
            print("inputStream")
        }
        if aStream == outputStream {
            print("outputStream")
        }
        switch eventCode {
        case .hasBytesAvailable:
            print("hasBytesAvailable")
            
            let data = Data(reading2: inputStream)
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            if str.contains("!") {
                sendDataAsMessage(stringData: messageManager.respondToMessage(requestObject: ELPClientRequestObject(message: str)))
            } else {
                let corrected = str.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil)
                if let message = try? JSONDecoder().decode(ELPClientResponseMessage.self, from: corrected.base64DecodedBytes!) {
                    messageManager.gotSharedMessage(message: message, data:corrected.base64DecodedBytes!)
                }
            }
            
        case .endEncountered:
            print("end of inputStream")
        case .errorOccurred:
            print("error occured")
        case .hasSpaceAvailable:
            print("has space available")
        case .openCompleted:
            //            isOpen = true
            print("open completed")
        default:
            print("StreamDelegate event")
        }
    }
    
    private func closeNetworkConnection() {
        inputStream.close()
        outputStream.close()
    }
    
    func StartClient(http: Bool, shared: Bool) {
        //http://localhost:5200/iosApi/FAHome
        print("ELPRequestClient start")
        

//        Stream.getStreamsToHost(withName: messageManager.IP , port: messageManager.port, inputStream: &inputStream, outputStream: &outputStream)

        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           messageManager.IP as CFString,
                                           messageManager.port,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.schedule(in: .main, forMode: .common)
        outputStream.schedule(in: .main, forMode: .common)
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.open()
        outputStream.open()
        
        if http {
            print("Connected http client " + messageManager.HttpApiKey + " " + messageManager.clientId + " " + messageManager.IP + ":" + String(messageManager.port))
            sendDataAsMessage(stringData: apiMessage(clientId: messageManager.clientId))
        }
        if shared {
            print("Connected shared tcp  " + messageManager.SharedApiKey + " " + messageManager.clientId + " " + messageManager.IP + ":" + String(messageManager.port))
            sendDataAsMessage(stringData: sharedApiMessage(clientId: messageManager.clientId))
        }
    }
    
    func stringToMessage(str: String) -> String {
        return str.base64Encoded! + ELProxyUtils.endOfMessage
    }
    
    func sharedApiMessage( clientId: String) -> String {
        let message = ELPRequestMessage(ClientId: messageManager.clientId, RequestIndex: "", ApiKey: messageManager.SharedApiKey, MessageType: ELPRequestMessage.sharedApiMessage)
        return message.ToJson()
    }
    
    func apiMessage( clientId: String) -> String {
        let message = ELPRequestMessage(ClientId: messageManager.clientId, RequestIndex: "", ApiKey: messageManager.HttpApiKey, MessageType: ELPRequestMessage.apiMessage)
        return message.ToJson()
    }
    
    func sendData(data: Data) {
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error joining chat")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func sendDataAsMessage(stringData: String) {
        let message = stringToMessage(str: stringData)
        print("sendDataAsMessage")
        sendData(data: message.data(using: .utf8)!)
    }
}