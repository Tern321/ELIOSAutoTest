//
//  main.swift
//  ELXibEditor
//
//  Created by jack on 07.01.2024.
//

import Foundation

print("Hello, World!")

var parser = MyXmlParser()
parser.test()


class MyXmlParser: NSObject, XMLParserDelegate {
    var depth = 0
    var depthIndent = 0
    static func readUTF16File(_ filePath: String) -> String {
        var text = ""
        do {
            text = try String(contentsOfFile: filePath, encoding: .utf16)
        } catch { print("readUTF16File error \(filePath)") }
        return text
    }
    
    static func readUTF8File(_ filePath: String) -> String {
        var text = ""
        do {
            text = try String(contentsOfFile: filePath, encoding: .utf8)
        } catch { print("readUTF8File error \(filePath)") }
        return text
    }
    
//    func parser(_ parser: XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {
//        print("name \(name)")
//    }
//    
//    
//    func parser(_ parser: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {
//        print("foundUnparsed name \(name)")
//    }
//    
//    
//    func parser(_ parser: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
//        print("attributeName \(attributeName)")
//    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("\(self.depthIndent)>\(elementName)")
        self.depth += 1
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.depth -= 1
        print("\(self.depthIndent)<\(elementName)")
    }
    
    func test() {
        var path = "/Users/jack/Documents/code/swift/ELIOSAutoTest.git/ELIOSAutoTest/Application/ViewControllers/Base.lproj/RootViewController.xib"
        let xml = MyXmlParser.readUTF8File(path)
//        print(xml)
        let xmlData = Data(xml.utf8)
        let xmlParser = XMLParser(data: xmlData)
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func test2() {
        
//        let url = URL(string: "/Users/jack/Documents/code/swift/ELIOSAutoTest.git/ELIOSAutoTest/Application/ViewControllers/Base.lproj/RootViewController.xib")!
//            var xml = XMLParser(contentsOfURL: url)
//
//            xml?.delegate = self
//            xml?.parse()
    }
}
