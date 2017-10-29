//
//  AddViewController.swift
//  SwiftMapDemo
//
//  Created by 高鑫 on 2017/10/29.
//  Copyright © 2017年 高鑫. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    
    var location : Location?
    let todayDate = Date()
    let formatter = DateFormatter()
    
    @IBAction func doneItem(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        location = Location(context: appDelegate.persistentContainer.viewContext)
        location?.name = textView.text
        formatter.dateFormat = "yyyy MM dd HH:mm:ss"
        location?.order = formatter.string(from: todayDate)
        print("正在保存")
        appDelegate.saveContext()
        let notification = Notification.Name.init("notification")
        NotificationCenter.default.post(name: notification, object: self)
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
