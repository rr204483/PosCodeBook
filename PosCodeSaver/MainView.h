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
#import "AddEditView.h"


@interface MainView : UITableViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchBarDelegate, UISearchDisplayDelegate, NSFetchedResultsControllerDelegate>  {

    UISearchBar *searchBar;
    NSArray *tableData;
    NSFetchedResultsController *fetchedResultsController;
    NSFetchedResultsController *searchFetchedResultsController;
    UITableView *searchTableView;
}

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
//@property(nonatomic, retain) UISearchBar *searchBar;
@property(nonatomic, retain) NSArray *searchResults;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSFetchedResultsController *searchFetchedResultsController;

@property(nonatomic, retain) NSArray *tableData;

//@property(nonatomic, retain) AddEditView *tableViewEdit;

@end
