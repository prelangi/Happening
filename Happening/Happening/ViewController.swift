//
//  ViewController.swift
//  Happening
//
//  Created by Douglas Hewitt on 10/24/15.
//  Copyright © 2015 TeamAwesomeHackingEDU. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate  {


    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var interestsTableView: UITableView!
    @IBOutlet weak var ideaStatus: UISwitch!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var activeStatus: UISwitch!
    @IBOutlet weak var doneButton: UIButton!
    
    var objects = [String]()
    var interestsChecked = [Bool]()
    var skillsArray = NSMutableArray()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        objects.append("iOS")
        objects.append("Android")
        objects.append("Web Development")
        objects.append("Hardware")
        objects.append("Gaming")
        
        interestsChecked.append(false);
        interestsChecked.append(false);
        interestsChecked.append(false);
        interestsChecked.append(false);
        interestsChecked.append(false);
        

        
    }
    
 
    
    @IBAction func didToggleActiveSwitch(sender: UISwitch) {
        if sender.on == true {
            PFUser.currentUser()?.setObject(true, forKey: "activeStatus")
            PFGeoPoint.geoPointForCurrentLocationInBackground {
                (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                if error == nil {
                    PFUser.currentUser()?.setObject(geoPoint!, forKey: "location")
                }
            }
        }
        else {
            PFUser.currentUser()?.setObject(false, forKey: "activeStatus")
        }
        PFUser.currentUser()?.saveEventually()
    }
    
    @IBAction func didToggleIdeaSwitch(sender: UISwitch) {
        if sender.on == true {
            PFUser.currentUser()?.setObject(true, forKey: "hasIdea")
        } else {
            PFUser.currentUser()?.setObject(false, forKey: "hasIdea")
        }
        PFUser.currentUser()?.saveEventually()
    }
    

    @IBAction func didPressLogout(sender: UIBarButtonItem) {
        PFUser.logOut()
        let logInController = PFLogInViewController()
        logInController.delegate = self
        logInController.signUpController?.delegate = self
        self.presentViewController(logInController, animated:true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            let logInController = PFLogInViewController()
//            logInController.fields = (PFLogInFields.UsernameAndPassword
//                | PFLogInFields.Facebook
//                | PFLogInFields.Twitter)
//            logInController.facebookPermissions = [ "friends_about_me" ]
            logInController.delegate = self
            logInController.signUpController?.delegate = self
            self.presentViewController(logInController, animated:true, completion: nil)
        }
        usernameLabel.text = PFUser.currentUser()?.objectForKey("username") as? String
    
        var currentActiveStatus: Bool? = PFUser.currentUser()?.objectForKey("activeStatus") as? Bool
        if currentActiveStatus == nil {
            PFUser.currentUser()?.setObject(true, forKey: "activeStatus")
//            print("set nil to true")
            currentActiveStatus = true
            PFUser.currentUser()?.saveEventually()
        }
        activeStatus.setOn(currentActiveStatus!, animated: false)
        
        var currentIdeaStatus: Bool? = PFUser.currentUser()?.objectForKey("hasIdea") as? Bool
        if currentIdeaStatus == nil {
            PFUser.currentUser()?.setObject(true, forKey: "hasIdea")
            currentIdeaStatus = true
            PFUser.currentUser()?.saveEventually()
        }
        ideaStatus.setOn(currentIdeaStatus!, animated: false)

    }
    
    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(controller: PFLogInViewController) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)

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
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = interestsTableView.cellForRowAtIndexPath(indexPath) {
            interestsChecked[indexPath.row] = !interestsChecked[indexPath.row]
            if(interestsChecked[indexPath.row]) {
                cell.accessoryType = .Checkmark
                
                skillsArray.addObject(objects[indexPath.row])
                PFUser.currentUser()?.setObject(skillsArray, forKey: "mySkills")
            }
            else {
                cell.accessoryType = .None
                skillsArray.removeObject(objects[indexPath.row])
                PFUser.currentUser()?.setObject(skillsArray, forKey: "mySkills")
            }
            PFUser.currentUser()?.saveEventually()
            
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let aCell = self.interestsTableView.dequeueReusableCellWithIdentifier("interestsCell", forIndexPath: indexPath) as! TableViewCell
        
        aCell.interestsLabel.text = self.objects[indexPath.row]
        
        let redimage : UIImage = UIImage(named:"Interest_Red.png")!
        let aquaimage : UIImage = UIImage(named:"Interest_Aqua.png")!
        let greenimage : UIImage = UIImage(named:"Interest_Green.png")!        
        let orangeimage : UIImage = UIImage(named:"Interest_Orange.png")!
        let purpleimage : UIImage = UIImage(named:"Interest_purple.png")!
        
        print("row: \(indexPath.row) ")
        print("The loaded image: \(redimage)")
        
        switch(indexPath.row) {
            case 0:
                
                aCell.iconView.image = redimage
                break
            case 1:
                aCell.iconView.image = aquaimage
                break
            case 2:
                aCell.iconView.image = greenimage
                break
            case 3:
                aCell.iconView.image = orangeimage
                break
            case 4:
                aCell.iconView.image = purpleimage
                break
        default: aCell.iconView.image = redimage
                break
            
        }
        
        return aCell
    }


}

