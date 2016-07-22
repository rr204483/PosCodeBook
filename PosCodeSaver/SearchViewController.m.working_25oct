//
//  ViewController.m
//  PosCodeSaver
//
//  Created by Ramesh on 03/10/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "PostCodes.h"
#import "PostCodeNew.h"
#import "editPostCode.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

//3.synenthesize the properties. assign the setters/getters for the declared views

@synthesize tableView;
@synthesize searchBar;
@synthesize tableData;
@synthesize searchResults;
@synthesize fetchedResultsController;
@synthesize fillteredData;
@synthesize posCodeNew;
@synthesize editPosCodeVC;
//@synthesize isLoading;
//@synthesize searchTableView;
//
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setTitle:@"All Addresses"];
    
    //getting singleton managedObjectContext
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    UIBarButtonItem *addBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAddPostCodeViewController)];
    
    self.navigationItem.rightBarButtonItem=addBarItem;
    [addBarItem release];
    
    //tableviews
    
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds
                         style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    /* Make sure our table view resizes correctly */
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    //datasource for tv
    
    self.tableData= [[NSMutableArray alloc] init];
    self.searchResults=[[NSMutableArray alloc] init];
    
    
    //UISearchBar implementation
    
   self.searchBar= [[UISearchBar alloc]
                    initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    
    //self.searchBar= [[UISearchBar alloc]init];
    self.searchBar.delegate=self;
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView=self.searchBar;
    [self.tableView reloadData];
    
    //[self.view addSubview:self.searchBar];
    
    UISearchDisplayController  *searchDisplayController= [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    searchDisplayController.delegate=self;
    searchDisplayController.searchResultsDelegate=self;
    searchDisplayController.searchResultsDataSource=self;
    self.tableView.tableHeaderView=self.searchBar;
    
    [self setUpDatabaseQueryEngine];
    
    self.posCodeNew= [[PostCodeNew alloc] initWithNibName:nil bundle:nil];
    self.editPosCodeVC= [[editPostCode alloc] initWithNibName:nil bundle:nil];
    
}

//core data fns : we are going to initialize an NSFetchRequest object and set some properties for it. Then we’ll initialize the fetchedResultsController object.

-(void) setUpDatabaseQueryEngine {
    // NSFetchRequest needed by the fetchedResultsController
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc] init];
    
    // NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reference" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription* entityDescription = [NSEntityDescription
                                              entityForName:@"PostCodes"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    [sortDescriptor release];
    [sortDescriptors release];
    //[NSFetchedResultsController deleteCacheWithName:@"poscode"];
    self.fetchedResultsController= [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate=self;

}

-(void) viewWillAppear:(BOOL)animated {
    //initialize the tableView with all the rows from table
    [self fetchResults:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [tableView release], tableView=nil;
    [searchBar release], searchBar=nil;
    [tableData dealloc];
    [super dealloc];
}

//TableView fns - start

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   NSLog(@"Number of rows in the %d section is :%d", section,[self.tableData count]);
    NSLog(@"table data :%@", self.tableData);
   return [self.tableData count];
//   id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
//  NSLog(@"Number of rows in the section:%d", [sectionInfo numberOfObjects]);
// return [sectionInfo numberOfObjects];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    //NSLog(@"index.row:%d", indexPath.row)   ;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setIndentationWidth:0.0];
    }

    //PostCodes *postCode = (PostCodes*) [self.tableData objectAtIndex:indexPath.row];
    PostCodes *postCode = (PostCodes*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text=postCode.reference;
    //NSLog(@"PostCode:%@", postCode.postCode);
    cell.detailTextLabel.text=postCode.postCode;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.editPosCodeVC.posCodeFromMainView=(PostCodes*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.editPosCodeVC.posCodeRecordIndex= [indexPath row];
    self.editPosCodeVC.posCodArray=self.tableData;
    [self.navigationController pushViewController:self.editPosCodeVC animated:YES];
}

//Tableview - swipe to delete
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath  {
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"commitEditingStyle:TableView is :%@", tableView);
    
     //NSLog(@"I.delete performed on indexPath:%@", indexPath);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //NSLog(@"Delete btn pressed");
        //delete the row from the data store
        
        // Delete the object from the data source
        NSManagedObject *objToDelete = (NSManagedObject*)[self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSLog(@"object to deleted:%@", objToDelete);
              // NSManagedObject *selectedObject = (NSManagedObject *) [self.tableData objectAtIndex:indexPath.row];
        
       // [NSIndexPath indexPathForRow:i inSection:0]
//        NSError *error;
//        
//        [self.managedObjectContext deleteObject:selectedObject]
//        [self.managedObjectContext save:&error];
//        
//        //delete from an array
//        [self.tableData removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
         // Delete the object from the database
        NSError *error = nil;

        [[self.fetchedResultsController managedObjectContext] deleteObject:objToDelete];
        //[self.managedObjectContext deleteObject:objToDelete];
//        if (![self.managedObjectContext save:&error]) {
//            NSLog(@"Error Saving: %@",[error description]);
//        }

        // Save Changes
        //[self.fetchedResultsController.managedObjectContext save:&error];
//        if ( ![[self.fetchedResultsController managedObjectContext] save:&error]) {
//            NSLog(@"Error Saving: %@",[error description]);
//            
//        }
        
//        if (tableView == self.searchDisplayController.searchResultsTableView ) {
//            
//            [self.searchDisplayController.searchResultsTableView reloadData];
//            
//            NSLog(@"This is search table view");
//            
//        }
//
       
        //        if (error) {
//            NSLog(@"Error %@ with user info %@.", error, error.userInfo);
//        }
//        
    }
        
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"controller didChangeObject:%@", anObject);
    

    
    
    //NSLog(@"didChangeObject tableView is :%@", tableView);
    
    switch(type) {
        case NSFetchedResultsChangeDelete :
           // NSLog(@"II delete performed on indexPath:%@", indexPath);
            // Because when you work with data source like NSFetchedResultsController, all changes must come from there and your table only reflects them.
            
//            if (tableView == self.searchDisplayController.searchResultsTableView ) {
//                
//                NSLog(@"This is search table view");
//                [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//
//                
//            } else
            
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self fetchResults:nil];
            //[self.tableView reloadData];
            break;
        default:
            break;
    }
   //  [self.tableView reloadData];
}

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
     //[self.tableView reloadData];
}
 
//  NSLog(@"commitEditingStyle...matchesArray:%@", self.matchesArray);


//TableView fns - end



-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchResults:searchBar.text];
    [self.tableView reloadData];
   //[self.searchDisplayController.searchResultsTableView reloadData];
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self fetchResults:self.searchBar.text];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    return YES;
}

-(void) fetchResults:(NSString *) searchString {
    
    //NSLog(@"User searching for :%@", searchString);
    
    NSPredicate *searchQuery;
    
    if (searchString != nil)
        searchQuery=[NSPredicate predicateWithFormat:@"reference contains %@", searchString];
    else {
        //searchQuery=[NSPredicate predicateWithFormat:@"All"];
        searchQuery=[NSPredicate predicateWithValue:YES];
    }
    
    [self.fetchedResultsController.fetchRequest setPredicate:searchQuery];
    
    NSError *error = nil;
    
    
    if (![[self fetchedResultsController] performFetch:&error])
    {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    //NSLog(@"before query : tableData count:%d fethed data count:%d", [self.tableData count], [fetchedResultsController.fetchedObjects count]);

    // this array is just used to tell the table view how many rows to show
    //NSLog(@"Fetching from db");
    //self.tableData=nil;
    self.tableData= fetchedResultsController.fetchedObjects;
    //NSLog(@"after query : tableData count:%d fethed data count:%d", [self.tableData count], [fetchedResultsController.fetchedObjects count]);
    //[self.searchBar resignFirstResponder];
    [self.tableView reloadData];
    
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //loading back the default values
    [self fetchResults:nil];
}

-(void) pushAddPostCodeViewController {
    
    self.posCodeNew.posCodArray=self.tableData;
    [self.navigationController pushViewController:self.posCodeNew animated:YES];

}

@end
