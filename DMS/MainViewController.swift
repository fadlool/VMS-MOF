//
//  MainViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit



@objc
protocol MainViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class MainViewController: UIViewController,UIActionSheetDelegate {
    
    
    @IBOutlet weak var topNavigationItem: UINavigationItem!
    var delegate: MainViewControllerDelegate?
    override func viewDidLoad() {
        
        if(NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.Arabic.rawValue){
            
            
            let homeBarBtnItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "menuTapped")
            
//            let button:UIButton  = UIButton(frame: CGRectMake(0, 0, 30, 30))
//            button.addTarget(self, action: "menuTapped", forControlEvents: UIControlEvents.TouchUpInside)
//            
//            button.setImage(UIImage(named: "MenuIcon"), forState: UIControlState.Normal)
//            button.setImage(UIImage(named: "MenuIcon"), forState: UIControlState.Highlighted)
//            let homeBarBtnItem:UIBarButtonItem = UIBarButtonItem(customView: button)
            
            
            let topMenuBtnItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "topMenuTapped")
            
            self.topNavigationItem.rightBarButtonItems = [homeBarBtnItem]
            self.topNavigationItem.leftBarButtonItems = [topMenuBtnItem]
            
        }else{
            
        
        }
    
    }
    
    func topMenuTapped(){
        
        let actionSheet:UIActionSheet  = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "cancel_dialog".localized, destructiveButtonTitle: nil, otherButtonTitles: "all_notifications".localized,"open_notifications".localized,"closed_notifications".localized,"cancelled_notifications".localized)

        actionSheet.showInView(self.view)
        
//
//        alloc] initWithTitle:nil
//                    delegate:self
//                    cancelButtonTitle:NSLocalizedString(@"cancel_dialog", nil)
//                    destructiveButtonTitle:nil
//                    otherButtonTitles:
//                    NSLocalizedString(@"move", nil),
//                    NSLocalizedString(@"restore", nil),  nil];

    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
    }
    func sideMenuTapped() {
        
        if(NSUserDefaults.standardUserDefaults().objectForKey(Common.UserLanguage)!.integerValue == Language.Arabic.rawValue){
            delegate?.toggleRightPanel?()
        
        }else{
            delegate?.toggleLeftPanel?()
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "show_profile"){
//            let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
//            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//            controller.detailItem = object
//            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//            controller.navigationItem.leftItemsSupplementBackButton = true
        
        
        }
    }
    
}

extension MainViewController: SidePanelViewControllerDelegate {
    func sideMenuItemSelected(sideMenuItem: SideMenuItem) {
       
        switch sideMenuItem.order {
        case Common.MenuProfileOrder:
            self.performSegueWithIdentifier("show_profile", sender: self)
        case Common.MenuIdentityReqOrder:
            print("The letter A")
            
        default:
            break
        }
        
        
        delegate?.collapseSidePanels?()
    }
}