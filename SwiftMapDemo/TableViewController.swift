//
//  TableViewController.swift
//  SwiftMapDemo
//
//  Created by 高鑫 on 2017/10/29.
//  Copyright © 2017年 高鑫. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var locations: [Location] = []
    var fc : NSFetchedResultsController<Location>!
    
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        let view = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let add = view.instantiateViewController(withIdentifier: "add")
        self.present(add, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 50
        self.tableView.tableFooterView = UIView()
        fetchAllCityInfos()
        let notification = Notification.Name.init("notification")
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: notification, object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reload(notification: Notification) {
        fetchAllCityInfos()
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDel = UIContextualAction(style: .destructive, title: "删除") { (action, view, finished) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(self.fc.object(at: indexPath))
            appDelegate.saveContext()
            finished(true)
        }
        actionDel.backgroundColor = UIColor(named: "iRed")
        return UISwipeActionsConfiguration(actions: [actionDel])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        let location = locations[indexPath.row]
        cell.nameLabel.text = location.name
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "mapSegue" {
            let viewController = segue.destination as! MapViewController
            viewController.locatioon = self.locations[tableView.indexPathForSelectedRow!.row]
        }
    }
    

}

extension TableViewController: NSFetchedResultsControllerDelegate {
    func fetchAllCityInfos() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptors]
        
        fc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fc.delegate = self
        
        do {
            try fc.performFetch()
            if let object = fc.fetchedObjects {
                locations = object
                print ("取回成功")
            }
        } catch {
            print ("取回失败")
        }
        self.tableView.reloadData()
    }
}

class tableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
}
