//
//  FilterDemoTableViewController.m
//  UITableViewFilterDemo
//
//  Created by Marty Dill on 12-03-24.
//  Copyright (c) 2012 Marty Dill. All rights reserved.
//

#import "FilterTableViewController.h"
//#import "DetailsViewController.h"
#import "MOF-Swift.h"


@implementation FilterTableViewController

@synthesize allTableData;
@synthesize filteredTableData;
@synthesize searchBar;
@synthesize isFiltered;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


- (void)backTapped{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    searchBar.delegate = (id)self;
    
    UIBarButtonItem *backButton  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil) style:UIBarButtonItemStyleDone target:self action:@selector(backTapped)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    Services *services = [[Services alloc] initWithViewController:self];
    allTableData = [[NSMutableArray alloc] init];
   [services getEmployeesList];
    
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;
    if(self.isFiltered)
        rowCount = filteredTableData.count;
    else
        rowCount = allTableData.count;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    DropDownItem* item;
    if(isFiltered)
        item = (DropDownItem*)[filteredTableData objectAtIndex:indexPath.row];
    else
        item = (DropDownItem*)[allTableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", item.idx];
    
    return cell;
}

#pragma mark - Table view delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];
        
        for (DropDownItem* item in allTableData)
        {
            NSRange nameRange = [item.title rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [filteredTableData addObject:item];
            }	
        }
    }
    
    [self.tableView reloadData];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}


-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    [self.searchBar resignFirstResponder];
    
    DropDownItem* item;
    
    if(isFiltered)
    {
        item = [filteredTableData objectAtIndex:indexPath.row];
    }
    else
    {
        item = [allTableData objectAtIndex:indexPath.row];
    }
    
    [self dismissViewControllerAnimated:true completion:nil];
    ((VacationReqVC*)self.vacReqController).selectedEmp = item;
}

@end
