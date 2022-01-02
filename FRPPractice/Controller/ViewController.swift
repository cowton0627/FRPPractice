//
//  ViewController.swift
//  FRPPractice
//
//  Created by Chun-Li Cheng on 2021/12/17.
//

import UIKit
import Combine

/*
 About FRP, is async、streams、observation programing attitude.
 */
class ViewController: UIViewController {
    let urlStr = URL(string: "https://www.appcoda.com.tw/")
    
    @IBOutlet weak var myBtn: UIButton!
    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var anotherImgVie: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        myBtn.configuration?.title = "請按我"
//        anotherImgVie.image = UIImage(systemName: "scribble")
   
//        print(myBtn.state)
        print(view.frame)
        print(navigationController?.viewControllers)
//        view.backgroundColor = .red
//        navigationController?.navigationBar.backgroundColor = .blue
//        title = "測試標題"
        
        let task = URLSession.shared.dataTask(with: urlStr!) { data, resp, error in
            
        }
        task.resume()
        
//        // 訂閱關係 - 建造關係
//        let subsription =
        // 發布者 - 建造者
        URLSession.shared.dataTaskPublisher(for: urlStr!)
        // 操作者 - 建造資訊
            .map { $0.data }
        // 訂閱者 - 建造
            .sink { comp in
                
            } receiveValue: { data in
                
            }
        
//        subsription
        
        // 建造者模式( builder pattern )
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.appcoda.com.tw"
        components.path =  "functional-reactive-programming/?fbclid=IwAR2vgW3l5Qfzjb-1iEXEUcTxOAtbFIkujStudtaqSL0EJUAlN9OKMsU9pPU"
//        components.queryItems =
        let url = components.url
        
        // 採用閉包, 即是得到callback方法(此處為網路請求後的回應)
//        let subscribe = { (completionHandler: @escaping (Data) -> Void) in
//            let task = URLSession.shared.dataTask(with: url!) {
//                data, resp, error in
//                if let data = data {
//                    completionHandler(data)
//                }
//            }
//            task.resume()
//        }
//
//        subscribe { data in
//
//        }
        
//        Publisher().subscribe { data in
//
//        }
        
//        Publisher { (completionHandler: @escaping (Data) -> Void) in
//            let urlStr = URL(string: "https://www.appcoda.com.tw/")
//            let task = URLSession.shared.dataTask(with: urlStr!) {
//                data, resp, error in
//                if let data = data {
//                    completionHandler(data)
//                }
//            }
//            task.resume()
//        }.subscribe { data in
//
//        }
        
//        Publisher<Notification> { handler in
//            NotificationCenter.default.addObserver(forName: UIWindow.keyboardDidShowNotification, object: nil, queue: nil) { notification in
//                handler(notification)
//            } as! Subscription
//        }.subscribe { notification in
//
//        }
        
//        let subscription = URLSession.shared.dataTaskPub(with: url!)
//            .subscribe { data in
//
//            }
//
//        subsription.cancel()
        
//        let suscription = URLSession.shared
//            .dataTaskPub(with: url!)
//            .map { $0.count }
//            .subscribe { count in
//
//            }
    }
    

}

class Subscription {
    let cancel: () -> Void
    init(cancel: @escaping () -> Void) {
        self.cancel = cancel
    }
    deinit {
        cancel()
    }
}

struct Publisher<T> {
    let subscribe: (@escaping (T) -> Void) -> Subscription
//    let subscribe = { (completionHandler: @escaping (Data) -> Void) in
//        let urlStr = URL(string: "https://www.appcoda.com.tw/")
//        let task = URLSession.shared.dataTask(with: urlStr!) {
//            data, resp, error in
//            if let data = data {
//                completionHandler(data)
//            }
//        }
//        task.resume()
//    }
    
}

extension Publisher {
    func map<NewValue>(_ transform: @escaping (T) -> NewValue) -> Publisher<NewValue> {
        return Publisher<NewValue> { completionHandler in
            return self.subscribe { t in
                let newValue = transform(t)
                completionHandler(newValue)
            }
            
        }
    }
}

extension URLSession {
    func dataTaskPub(with url: URL) -> Publisher<Data> {
//        return Publisher<Data> { (completionHandler: @escaping (Data) -> Void) in
            let urlStr = URL(string: "https://www.appcoda.com.tw/")
//            let task = URLSession.shared.dataTask(with: urlStr!) {
//                data, resp, error in
//                if let data = data {
//                    completionHandler(data)
//                }
//            }
        
        return Publisher<Data> { completionHandler in
            let task = self.dataTask(with: url) { data, resp, error in
                if let data = data {
                    completionHandler(data)
                }
            }
            task.resume()
            
            return Subscription {
                task.cancel()
            }
            
        }
//        }
    }
    
}


