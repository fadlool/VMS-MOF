//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit


protocol SidePanelViewControllerDelegate {
    func sideMenuItemSelected(SideMenuItem: SideMenuItem)
}

class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: SidePanelViewControllerDelegate?
    
    var SideMenuItems: Array<SideMenuItem>!
    
    struct TableView {
        struct CellIdentifiers {
            static let SideMenuItemCell = "SideMenuItemCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.SideMenuItemCell, forIndexPath: indexPath) as! SideMenuItemCell
        cell.configureForSideMenuItem(SideMenuItems[indexPath.row])
        return cell
    }
    
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedSideMenuItem = SideMenuItems[indexPath.row]
        delegate?.sideMenuItemSelected(selectedSideMenuItem)
    }
    
}

class SideMenuItemCell: UITableViewCell {
    
    @IBOutlet weak var sideMenuItemImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    
    func configureForSideMenuItem(sideMenuItem: SideMenuItem) {
        sideMenuItemImageView.image = sideMenuItem.image
        imageNameLabel.text = sideMenuItem.title 
    }
    
}