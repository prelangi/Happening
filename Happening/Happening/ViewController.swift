//
//  ViewController.swift
//  Happening
//
//  Created by Douglas Hewitt on 10/24/15.
//  Copyright © 2015 TeamAwesomeHackingEDU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var interestsTableView: UITableView!
    @IBOutlet weak var ideaStatus: UISwitch!
    @IBOutlet weak var activeStatus: UISwitch!
    @IBOutlet weak var profileImage: UIImageView!
    var objects = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        objects.append("iOS")
        objects.append("Android")
        objects.append("Web Development")
        objects.append("Hardware")
        objects.append("Gaming")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.objects.count
    }

    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String
    {
        switch(section)
        {
        case 0:return "Interests"
            break
        default :return ""
            break
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let aCell = self.interestsTableView.dequeueReusableCellWithIdentifier("interestsCell", forIndexPath: indexPath) as! TableViewCell
        aCell.interestsLabel.text = self.objects[indexPath.row]
        return aCell
    }


}

