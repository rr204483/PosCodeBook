//
//  ViewController.m
//  PosCodeSaver
//
//  Created by Ramesh on 03/10/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import "MainView.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "PostCodes.h"
#import "AddEditView.h"

#define HOUSENO @"HouseNo"
#define PCODE @"PostCode"
#define REF @"Reference"
#define NOTES @"Notes"

@interface MainView ()

@end

@implementation MainView

//http://stackoverflow.com/questions/4471289/how-to-filter-nsfetchedresultscontroller-coredata-with-uisearchdisplaycontroll

//@synthesize searchBar;
@synthesize searchResults;
@synthesize fetchedResultsController;
@synthesize searchFetchedResultsController;
@synthesize managedObjectContext;

@synthesize tableData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setTitle:@"PostCodes"];
    
    //getting singleton managedObjectContext
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    //addBar item
    UIBarButtonItem *addBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAddPostCodeViewController)];
    
    self.navigationItem.rightBarButtonItem=addBarItem;
    [addBarItem release];
    
    //tableviews
    //ToDo : check with Kalai. do we need to allocate the tableView
    self.tableView=[[[UITableView alloc] initWithFrame:self.view.bounds
                         style:UITableViewStyleGrouped] autorelease];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    
    /* Make sure our table view resizes correctly */
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *tableBgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgImg.png"]];
    [tableBgImgView setFrame:self.tableView.frame];
    [self.tableView setBackgroundView:tableBgImgView];
    [tableBgImgView release];
    
    //datasource for tv
    self.searchResults=[[[NSMutableArray alloc] init] autorelease];
    
    
    //UISearchBar implementation
    
    searchBar= [[[UISearchBar alloc]
                    initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)] autorelease];
    
    //self.searchBar= [[UISearchBar alloc]init];
    searchBar.delegate=self;
    [searchBar sizeToFit];
    self.tableView.tableHeaderView=searchBar;
    //self.searchBar.tintColor=[UIColor blueColor];
    //You should set the backgroundColor to one that has less then 1.0 alpha to generate transparancy
    [searchBar setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
    [self.tableView reloadData];
    
    UISearchDisplayController  *searchDisplayController= [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate=self;
    searchDisplayController.searchResultsDelegate=self;
    searchDisplayController.searchResultsDataSource=self;
    self.tableView.tableHeaderView=searchBar;
    //[self.tableView autorelease];
    //self.tableViewEdit=[[AddEditView alloc] initWithNibName:nil bundle:nil];
    //self.tableViewEdit.dicOfPostCodes= [[NSMutableDictionary alloc] init];
    
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitle:@"PostCodes"];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    }

//I created a helpful method to retrieve the correct FRC when working with all of the UITableViewDelegate/DataSource methods:

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
    return tableView == self.tableView ? self.fetchedResultsController : self.searchFetchedResultsController;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[[self fetchedResultsControllerForTableView:tableView] sections] count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    NSFetchedResultsController *fetchController = [self fetchedResultsControllerForTableView:tableView];
    NSArray *sections = fetchController.sections;
    if(sections.count > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
    
}

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsControllerArg configureCell:(UITableViewCell *)theCell atIndexPath:(NSIndexPath *)theIndexPath
{
    // your cell guts here
    PostCodes *postCodetmp = (PostCodes*)[fetchedResultsControllerArg objectAtIndexPath:theIndexPath];
    theCell.textLabel.text=postCodetmp.reference;
    theCell.textLabel.font=[UIFont fontWithName:@"Noteworthy-Bold" size:17];
    theCell.detailTextLabel.text=postCodetmp.postCode;
    theCell.detailTextLabel.font=[UIFont fontWithName:@"Noteworthy-Light" size:16];
    theCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    //NSLog(@"index.row:%d", indexPath.row)   ;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
        [cell setIndentationWidth:0.0];
    }
    // Background color when selecting a cell
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    [self fetchedResultsController:[self fetchedResultsControllerForTableView:theTableView] configureCell:cell atIndexPath:theIndexPath];
    
    return cell;
}


//Delegate methods for the search bar:

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    switch(type)
    {
        //we are not using insert but we must need this to propagate the changes correctly in the tableview
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

//this fn will be called whenever some change happens in managedObjectContext
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)theIndexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self fetchedResultsController:controller configureCell:[tableView cellForRowAtIndexPath:theIndexPath] atIndexPath:theIndexPath];
            break;
            
           //ToDo : Keep this part we might need to support move in the future
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
//            break;
    }

}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView endUpdates];
}


//FRC Creating code

- (NSFetchedResultsController *)newFetchedResultsControllerWithSearch:(NSString *)searchString
{
    
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];

    // NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reference" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    
    NSEntityDescription* entityDescription = [NSEntityDescription
                                              entityForName:@"PostCodes"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    [sortDescriptor release];
    [sortDescriptors release];
    
    //NSPredicate *filterPredicate = [NSPredicate predicateWithValue:YES];
    NSPredicate *filterPredicate;
    //using ANY for in-case sensitive search
    //http://stackoverflow.com/questions/1473973/nspredicate-case-insensitive-matching-on-to-many-relationship
    //Any should be used only with to-many relationships.
    ////        filterPredicate = [NSPredicate predicateWithFormat:@"(ANY reference contains[c] %@) OR (ANY postCode contains[c] %@)", searchString, searchString ];
    
    if(searchString.length)
        filterPredicate = [NSPredicate predicateWithFormat:@"(reference contains[cd] %@) OR (postCode contains[cd] %@)", searchString, searchString ];
    else
        filterPredicate = [NSPredicate predicateWithValue:YES];
    
    [fetchRequest setPredicate:filterPredicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                        cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    [fetchRequest release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    self.tableData=aFetchedResultsController.fetchedObjects;
    
    return aFetchedResultsController;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil)
    {
        return fetchedResultsController;
    }
    fetchedResultsController = [self newFetchedResultsControllerWithSearch:nil];
    return [[fetchedResultsController retain] autorelease];
}

- (NSFetchedResultsController *)searchFetchedResultsController
{
    if (searchFetchedResultsController != nil)
    {
        return searchFetchedResultsController;
    }
    searchFetchedResultsController = [self newFetchedResultsControllerWithSearch:self.searchDisplayController.searchBar.text];
    return [[searchFetchedResultsController retain] autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [super dealloc];
    [searchBar release], searchBar=nil;
    //[self.tableView release];
}

//Tableview - swipe to delete
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath  {
    return YES;
}


-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSFetchedResultsController *aFetchedResultsController=[self fetchedResultsControllerForTableView:tableView];
//        aFetchedResultsController.delegate=self;
        
        // Delete the object from the data source
        NSManagedObject *objToDelete = (NSManagedObject*)[aFetchedResultsController objectAtIndexPath:indexPath];

        [aFetchedResultsController.managedObjectContext deleteObject:objToDelete];
        NSError *error = nil;
        BOOL success = [self.fetchedResultsController.managedObjectContext save:&error];
        if (!success) {
            // do error handling here.
            NSLog(@"Error Saving: %@",[error description]);
        }
        
     }
    
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
{
    // update the filter, in this case just blow away the FRC and let lazy evaluation create another with the relevant search info
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
    // if you care about the scope save off the index to be used by the serchFetchedResultsController
    //self.savedScopeButtonIndex = scope;
}


#pragma mark -
#pragma mark Search Bar

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    
//    UIImageView *tableBgImgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgImg.png"]];
//    [tableBgImgView1 setFrame:self.searchDisplayController.searchResultsTableView.frame];
//    [self.searchDisplayController.searchResultsTableView setBackgroundView:tableBgImgView1];
//    //[tableBgImgView1 release];
//    
//   // [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImg.png"]]];
//    [self.searchDisplayController.searchResultsTableView setSeparatorColor:[UIColor clearColor]];
//    //[self.searchDisplayController.searchResultsTableView setBackgroundView:<#(UIView *)#>]
//   [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}
- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
{
    // search is done so get rid of the search FRC and reclaim memory
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(void) pushAddPostCodeViewController {
    //Todo : check with kalai, is the name "Home" okay ? or should i have any other name like "Main"
    [self setTitle:@"Back"];
    AddEditView *tableViewEdit=[[AddEditView alloc] initWithNibName:nil bundle:nil];
    //tableViewEdit.dicOfPostCodes= [[NSMutableDictionary alloc] init];
    tableViewEdit.isInvokedToAdd=YES;
    [self.navigationController pushViewController:tableViewEdit animated:YES];
    [tableViewEdit release];


}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddEditView *tableViewEdit=[[AddEditView alloc] initWithNibName:nil bundle:nil];
    tableViewEdit.dicOfPostCodes= [[[NSMutableDictionary alloc] init] autorelease];

    //To find out which controller is active
    NSFetchedResultsController *fetchController=[self fetchedResultsControllerForTableView:tableView];
    
    PostCodes *selectedObj=(PostCodes*)[fetchController objectAtIndexPath:indexPath];

    //self.tableViewEdit.currentPosCodeObj=(PostCodes*)[fetchController objectAtIndexPath:indexPath];
    //self.tableViewEdit.posCodeRecordIndex= [indexPath row];
    self.tableData=fetchController.fetchedObjects;
    [self setTitle:@"Back"];
    tableViewEdit.isInvokedToAdd=NO;
    //self.tableViewEdit.posCodArray=self.tableData;
    
    //populating the local array from the passed row value
    [tableViewEdit.dicOfPostCodes setObject:selectedObj.postCode forKey:PCODE];
    [tableViewEdit.dicOfPostCodes setObject:selectedObj.reference forKey:REF];
    [tableViewEdit.dicOfPostCodes setObject:selectedObj.houseNumber forKey:HOUSENO];
    if ( ![selectedObj.notes length] == 0)
        [tableViewEdit.dicOfPostCodes setObject:selectedObj.notes forKey:NOTES];

    [self.navigationController pushViewController:tableViewEdit animated:YES];
    [tableViewEdit release];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
         return 60;
    
}

@end
