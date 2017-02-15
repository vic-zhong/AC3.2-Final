//
//  PicsTableViewController.swift
//  AC3.2-Final
//
//  Created by Victor Zhong on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class PicsTableViewController: UITableViewController {
    
    var databaseReference: FIRDatabaseReference!
    var pics = [Pic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseReference = FIRDatabase.database().reference().child("posts")
        getLinks()
        self.tableView.estimatedRowHeight = 150.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getLinks()
        self.parent?.navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Functions
    
    func getLinks() {
        databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            self.pics.removeAll()
            
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String:String] {
                    let pic = Pic(key: snap.key,
                                  user: valueDict["userID"] ?? "",
                                  comment: valueDict["comment"] ?? "")
                    self.pics.append(pic)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseID", for: indexPath) as! PicsTableViewCell
        
        let pic = pics[indexPath.row]
        cell.commentLabel.text = pic.comment
        
        let storage = FIRStorage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference(forURL: "gs://ac-32-final.appspot.com")
        let spaceRef = storageRef.child("images/\(pic.key)")
        spaceRef.data(withMaxSize: 1 * 800 * 800) { data, error in
            if let error = error {
                print(error)
            }
            else {
                let image = UIImage(data: data!)
                cell.picView.image = image
            }
        }
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
