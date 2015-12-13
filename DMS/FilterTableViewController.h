//
//  FilterDemoTableViewController.h
//  UITableViewFilterDemo
//
//  Created by Marty Dill on 12-03-24.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray* allTableData;
@property (strong, nonatomic) NSMutableArray* filteredTableData;

@property (strong, nonatomic) UIViewController * vacReqController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) bool isFiltered;

@end
