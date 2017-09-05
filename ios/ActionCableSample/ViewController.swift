//
//  ViewController.swift
//  ActionCableSample
//
//  Created by Yusuke Ariyoshi on 2017/05/20.
//  Copyright © 2017年 Yusuke Ariyoshi. All rights reserved.
//

import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import ActionCableClient

class ViewController: UIViewController {
    
    @IBOutlet weak var receivedBodyLabel: UILabel!
    
    var client: ActionCableClient!
    var chatChannel: Channel?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client = ActionCableClient(url: URL(string: "ws://163.44.175.23:3000/cable")!)
        client.connect()
        
        client.onConnected = {
            print("Connected!")
            
            self.chatChannel = self.client.create("ChatChannel")
            if let chatChannel = self.chatChannel {
                chatChannel.onReceive = { (JSON : Any?, error : Error?) in
                    // receive message
                    if let json = JSON {
                        print("Received: ", json)
                        self.receivedBodyLabel.text = (json as! NSDictionary)["message"] as? String
                    }
                    if let error = error {
                        print("Received: ", error)
                    }
                }
                
                chatChannel.onSubscribed = {
                    print("Subscribed")
                }
                
                chatChannel.onUnsubscribed = {
                    print("Unsubscribed")
                }
                
                chatChannel.onRejected = {
                    print("Rejected")
                }
            }
        }
        
        client.onDisconnected = {(error: Error?) in
            print("Disconnected!")
            print(error!)
        }
    }
    
    @IBAction func didTapSendButton(_ sender: Any) {
        guard let chatChannel = chatChannel else { return }
        // send message
        let random = arc4random() % 10
        if let error = chatChannel["create"](["content": "hello: " + String(random)]) {
            print("Error: ", error)
        }
    }
}
