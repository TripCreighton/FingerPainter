//
//  SettingsTVC.swift
//  FingerPainter
//
//  Created by Trip Creighton on 2/2/17.
//  Copyright © 2017 Trip Creighton. All rights reserved.
//

import UIKit
import Photos

class SettingsTVC: UITableViewController {
    @IBOutlet var saveCanvasSwitch: UISwitch!

    private let defaults = UserDefaults()
    
    private var saveCanvasState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        //Remove extra empty cells:
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 230)
        
        //Retrieve keys:
        saveCanvasState = defaults.bool(forKey: "saveCanvasState")
        saveCanvasSwitch.isOn = saveCanvasState
    }
    
    @IBAction func saveCanvasPressed(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: "saveCanvasState")
    }
    
    
    /* Tableview Overrides */

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerLabel = (view as! UITableViewHeaderFooterView).textLabel {
            headerLabel.textColor = UIColor(r: 1 , g: 127, b: 202, a: 255)
        }
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
