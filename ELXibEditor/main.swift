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
    
    /*
     <document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="22155" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">
         <device id="retina6_1" orientation="portrait" appearance="light"/>
         <dependencies>
             <deployment identifier="iOS"/>
             <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="22131"/>
             <capability name="Safe area layout guides" minToolsVersion="9.0"/>
             <capability name="System colors in document resources" minToolsVersion="11.0"/>
             <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
         </dependencies>
         <objects>
             <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner" customClass="RootViewController" customModule="ELIOSAutoTest" customModuleProvider="target">
                 <connections>
     
     
     */
    func recursiveSearch(_ element: XMLNode) {
        for child in element.children ?? [] {
            recursiveSearch(child)
        }
        if element.name == "label" {
            print("label")
            element.at
        }
    }
    func test() {
        
        do {
            var path = "/Users/jack/Documents/code/swift/ELIOSAutoTest.git/ELIOSAutoTest/Application/ViewControllers/Base.lproj/RootViewController.xib"
            var path2 = "/Users/jack/Documents/code/swift/ELIOSAutoTest.git/ELIOSAutoTest/Application/ViewControllers/Base.lproj/RootViewController_edited.xib"
            let xml = MyXmlParser.readUTF8File(path)
    //        print(xml)
            var doc = try XMLDocument(xmlString: xml)
            
            var testElement = XMLElement(name: "testElement", stringValue:"testElementValue" )
            doc.rootElement()?.addChild(testElement)
            var connections = try doc.rootElement()?.nodes(forXPath: "./objects/placeholder/connections/*")
            var labels = try doc.rootElement()?.nodes(forXPath: "*/label" )//
            
            recursiveSearch(doc.rootElement()!)
//            connections?.ele
//            doc.rootElement()?.addAttribute(/*<#T##attribute: XMLNode##XMLNode#>*/)
            
            try doc.xmlData.write(to: URL(fileURLWithPath: path2))
        } catch {
            print("error")
        }
        
//        doc.rootElement()
        
//        let xmlData = Data(xml.utf8)
//        let xmlParser = XMLParser(data: xmlData)
//        xmlParser.delegate = self
//        xmlParser.parse()
//        xmlParser
    }
    
    func test2() {
        
//        let url = URL(string: "/Users/jack/Documents/code/swift/ELIOSAutoTest.git/ELIOSAutoTest/Application/ViewControllers/Base.lproj/RootViewController.xib")!
//            var xml = XMLParser(contentsOfURL: url)
//
//            xml?.delegate = self
//            xml?.parse()
    }
}
