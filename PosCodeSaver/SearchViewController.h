//
//  ViewController.h
//  PosCodeSaver
//
//  Created by Ramesh on 03/10/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PostCodeNew.h"
#import "editPostCode.h"

@interface SearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchBarDelegate, UISearchDisplayDelegate, NSFetchedResultsControllerDelegate>  {
    //1. instance variable
    UITableView *tableView;
    UISearchBar *searchBar;
    NSArray *tableData;
    NSArray *fillteredData;
    
    NSFetchedResultsController *fetchedResultsController;
    
    BOOL isLoading;
    UITableView *searchTableView;
    
    PostCodeNew *posCodeNew;
    BOOL isSearchActive;
    
}

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;

//2. properties
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UISearchBar *searchBar;
@property(nonatomic, retain) NSArray *tableData;
@property(nonatomic, retain) NSArray *fillteredData;

@property(nonatomic, retain) NSArray *searchResults;

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
//@property(nonatomic) BOOL isLoading;
//@property(nonatomic, strong) UITableView *searchTableView;

@property(nonatomic, retain) PostCodeNew *posCodeNew;
@property(nonatomic, retain) editPostCode *editPosCodeVC;

@property(nonatomic) BOOL isSearchActive;



@end
