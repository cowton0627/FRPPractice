//
//  SecondViewController.swift
//  FRPPractice
//
//  Created by Chun-Li Cheng on 2021/12/18.
//

import UIKit

class SecondViewController: UIViewController, XMLParserDelegate {
    @IBOutlet weak var myTableView: UITableView!
    private var tagName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        myTableView.delegate = self
//        myTableView.dataSource = self
        guard let url = Bundle.main.url(forResource: "test", withExtension: "xml") else {
            return
        }
        if let xml = XMLParser(contentsOf: url) {
            xml.delegate = self
            xml.parse()
//            parser(xml, foundCharacters: "scenes")
            xml.shouldResolveExternalEntities = true
        }
        
        /*
            GCD是以閉包的方式來安排佇列與線程, 就像ARC不需特別分配記憶體與釋放記憶體
            佇列 DispatchQueue (serial / concurrent)
                其中 mainQueue是serial，執行時會放在主線程，常用如更新UI；
                globalQueue是concurrent，需設定優先層級
         
                因其是FIFO，所以mainQueue執行下載會卡線程，例如畫面未更新時APP卡住不動
                且globeQueue需在async下才能併發，因為sync不會開新執行緒
         
                所以一般mainQueue會接async，global也會接async
         
            線程 sync / async
                同步與異步，同步的意思在當前執行緒執行，異步的意思是開新執行緒一起執行
         
                global只用sync，將只有serial的效果
         
            結果
                併發同步：依序執行
                併發異步：交替執行
                順序同步：依序執行
                順序異步：依序執行
         
         */
//        let concurrentQueue: DispatchQueue = DispatchQueue(label: "CorrentQueue", attributes: .concurrent)
//        concurrentQueue.sync {
//            for i in 1 ... 100 {
//                print("i: \(i)")
//            }
//        }
//        concurrentQueue.async {
//            for j in 1 ... 100 {
//                print("j: \(j)")
//            }
//        }
//        concurrentQueue.async {
//            for k in 1 ... 100 {
//                print("k: \(k)")
//            }
//        }
        
        let group: DispatchGroup = DispatchGroup()

               let queue1 = DispatchQueue(label: "queue1", attributes: .concurrent)
               queue1.async(group: group) {
                   // 事件A
                   for i in 1 ... 100 {
                       print("i: \(i)")
                   }
               }
               let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
               queue2.async(group: group) {
                   // 事件B
                   for j in 101 ... 200 {
                       print("j: \(j)")
                   }
               }

               group.notify(queue: DispatchQueue.main) {
                   // 已處理完事件A和事件B
                   print("處理完事件A和事件B")
               }
        
//        let group: DispatchGroup = DispatchGroup()
//
//        let queue1 = DispatchQueue(label: "queue1", attributes: .concurrent)
//        group.enter() // 開始呼叫 API1
//        queue1.async(group: group) {
//          // Call 後端 API1
//          // 結束呼叫 API1
//            for i in 1 ... 100 {
//                print("i: \(i)")
//            }
//          group.leave()
//        }
//
//        let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
//        group.enter() // 開始呼叫 API2
//        queue2.async(group: group) {
//          // Call 後端 API2
//          // 結束呼叫 API2
//            for j in 101 ... 200 {
//                print("j: \(j)")
//            }
//          group.leave()
//        }
//
//        group.notify(queue: DispatchQueue.main) {
//          // 完成所有 Call 後端 API 的動作
//          print("完成所有 Call 後端 API 的動作")
//        }
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "device":
            for key in attributeDict.keys {
                guard let value = attributeDict[key] else {
                    return
                }
                print("\(key): \(value)")
            }
        case "dependencies":
            for key in attributeDict.keys {
                guard let value = attributeDict[key] else {
                    return
                }
                print("\(key): \(value)")
            }
        case "plugIn":
            for key in attributeDict.keys {
                guard let value = attributeDict[key] else {
                    return
                }
                print("\(key): \(value)")
            }
        case "capability":
            for key in attributeDict.keys {
                guard let value = attributeDict[key] else {
                    return
                }
                
                print("\(key): \(value)")
            }
        default:
//            break
            tagName = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let tagNmae = tagName else {
            return
        }

        print("\(tagNmae): \(string)")

    }
    
    func parser(_ parser: XMLParser, didEndElement elementName : String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "device":
            fallthrough
        case "dependencies":
            fallthrough
        case "plugIn":
            fallthrough
        case "capability":
            fallthrough
        default:
//            break
            tagName = elementName
        }
    }

}
