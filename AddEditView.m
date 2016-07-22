//
//  AddEditView.h
//  PosCodBook
//
//  Created by Ramesh on 25/10/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import "AddEditView.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "PostCodes.h"
#import "CustomCell.h"
#import "Validators.h"

#define HOUSENO @"HouseNo"
#define PCODE @"PostCode"
#define REF @"Reference"
#define NOTES @"Notes"

//Tags
#define PCODETAG 10
#define REFTAG 20
#define HOUSENOTAG 30
#define NOTESTAG 40

//#define PCODELENGTH 10
//#define HOUSENOLENGTH 1000
@interface AddEditView ()

@end

@implementation AddEditView
@synthesize managedObjectContext;
@synthesize posCodArray;
@synthesize currentPosCodeObj;
@synthesize isInvokedToAdd;
@synthesize dicOfPostCodes;
@synthesize dicOfPostCodesBackUp;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //getting singleton managedObjectContext
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                       target:self action:@selector(save)];
    
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                         target:self action:@selector(cancel)];
        
    self.tableView=[[[UITableView alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStyleGrouped] autorelease];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *tableBgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgImg.png"]];
    [tableBgImgView setFrame:self.tableView.frame];
    [self.tableView setBackgroundView:tableBgImgView];
    [tableBgImgView release];


    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tgr.delegate =(id) self;
    tgr.cancelsTouchesInView=NO;
    [self.tableView addGestureRecognizer:tgr]; // or [self.view addGestureRecognizer:tgr];
    [tgr release];
        
    dicOfPostCodesBackUp= [[NSMutableDictionary alloc] init];
}

-(void) viewWillAppear:(BOOL)animated {
    //http://stackoverflow.com/a/12426523/1451774
    //using viewWillAppear in a UITableViewController breaks the "automagic tableView scrolling up when keyboard appears" behaviour.
    [super viewWillAppear:animated] ;
    
    //if this VC is called from main controllers Add('+')'s btn, isInvokedToAdd set to Yes.
    if (isInvokedToAdd) {
        [self setTitle:@"New PostCode"];
        [self setEditing:YES animated:YES];
         
        //loop through the cell to get the values and empties for the first time display
        for (CustomCell *cell in [self.tableView visibleCells]) {
           //NSLog(@"cell is emptied");
            if (cell.key==NOTES)
                cell.textView.text=@"";
            else
                cell.textField.text=@"";
        }
        //clearing off the array for eachtime display
        [dicOfPostCodes removeAllObjects];

    } else { //called for didSelectIndexPath from main tableview
        
        [self setTitle:@"PostCode"];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self setEditing:NO animated:NO];
        dicOfPostCodesBackUp = [dicOfPostCodes mutableCopy];
        [self.tableView reloadData];
        
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* this is optional, it let u choose witch touches to receive, for example here I'm checking if user has tapped on a textField */
//http://stackoverflow.com/questions/13275195/shouldreceivetouch-on-uitableviewcellcontentview
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITableView class]]) {
        //remove keyboard when user touches outside of rows/sections
        [[self tableView] endEditing:YES];
    }
     // UITableViewCellContentView => UITableViewCell
    if (([touch.view isKindOfClass:[UITableViewCell class]]) ||
        ([touch.view.superview isKindOfClass:[UITableViewCell class]]) ||
        ([touch.view.superview.superview isKindOfClass:[UITableViewCell class]])) {
        
        //this check avoids calling setEditing whenever user taps the textfield even after it is already in the edit mode
        if (!self.editing) {
            [self setEditing:YES animated:YES];

        }
    }
    return YES; 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
        return 3;
    else //if (section == 1)
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyCell";
    CustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        UIView *vertLineView;
        if (indexPath.section == 1)
            //for address field, separator at different place
            vertLineView =  [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, 150)];
        
        else
            vertLineView =  [[UIView alloc] initWithFrame:CGRectMake(125, 0, 1, 44)];

        vertLineView.backgroundColor=[UIColor grayColor];
        [cell.contentView addSubview:vertLineView];
        [vertLineView release];
    }
    
    switch (indexPath.section) {
            
        case 0:
            if (indexPath.row == 0) {
                cell.label.text=PCODE;
                cell.textField.text= (isInvokedToAdd) ? cell.textField.text:[self.dicOfPostCodes objectForKey:PCODE];
                cell.key=cell.label.text;
                cell.textField.autocapitalizationType=UITextAutocapitalizationTypeAllCharacters;
                cell.textField.tag=PCODETAG;
  
            } else if (indexPath.row == 1) {
                cell.label.text=REF;
                cell.textField.text=(isInvokedToAdd) ? cell.textField.text:[self.dicOfPostCodesBackUp objectForKey:REF] ;
                cell.key=cell.label.text;
                cell.textField.tag=REFTAG;

            } else if (indexPath.row == 2) {
                cell.label.text=HOUSENO;
                cell.textField.text=(isInvokedToAdd) ? cell.textField.text:[[self.dicOfPostCodes objectForKey:HOUSENO] intValue]?[[self.dicOfPostCodes objectForKey:HOUSENO] stringValue]:@"" ;
                
                cell.key=cell.label.text;
                cell.textField.tag=HOUSENOTAG;
                cell.textField.keyboardType=UIKeyboardTypeNumberPad;
              }
            cell.textField.delegate=self;
            break;
        
        case 1:
            cell.label.text=NOTES;
            cell.textView.hidden=NO;
            cell.textView.text=(isInvokedToAdd) ? cell.textView.text:[self.dicOfPostCodes objectForKey:NOTES] ;
            cell.key=cell.label.text;
            cell.textView.tag=NOTESTAG;
            cell.textField.tag=NOTESTAG;
            cell.textView.delegate=self;
            break;
            
    }

    return cell;
}

- (CGFloat)     tableView:(UITableView *)tableView
 heightForHeaderInSection:(NSInteger)section{
        
    if (section == 1)
        return 10.0f;
    else
        return 40.0f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == 0)
            return 44;
        else //if (indexPath.section == 1)
           return 150;
       
}

//ToDo: Why setEditing has been called for number of times
//ToDo: If nothing is editing , don't need to update the record
//Todo:
-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    
   //NSLog(@" got into setEditing");
    
   [super setEditing:editing animated:animated];
    
    self.navigationItem.rightBarButtonItem = (editing) ? saveButton : self.editButtonItem;
    //if set as nil, then the backbutton will show by default.
    //This is similar to [self.navigationItem setHidesBackButton:NO]
    self.navigationItem.leftBarButtonItem = (editing) ? cancelButton : nil;
        
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//This fun will be called for each row

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)save
{
    //NSLog(@"before cell loop through: dic is :%@", dicOfPostCodes);
    if (dicOfPostCodes == nil) {
        //NSLog(@"dic is nil");
        dicOfPostCodes= [[NSMutableDictionary alloc]init] ;
    }

    for (CustomCell *cell in [self.tableView visibleCells]) {
//        NSLog(@"cell.key :%@ and cell.text is :%d text :%@", cell.key, cell.textField.tag, cell.textField.text);
        NSString *key = [self getKeyForTag:cell.textField.tag];
        NSString *value = cell.textField.text;
        
        if (cell.textView.tag == NOTESTAG) {
            key=NOTES;
            value=cell.textView.text;
        }
        
        if ([Validators isEmpty:value]) {
            [dicOfPostCodes removeObjectForKey:key];
        } else {
            if ((key == PCODE) || (key == REF)) {
                [dicOfPostCodes setObject:value forKey:key];
                //NSLog(@"setting the value dic is :%@ : value: %@ key:%@", self.dicOfPostCodes, value, key);

            }
            else if (key == HOUSENO)
                [dicOfPostCodes setObject:[NSNumber numberWithInt:value.intValue] forKey:key];
            else if (key == NOTES )
                [dicOfPostCodes setObject:value forKey:NOTES];
        }
        
    }
    
    //NSLog(@"after : dic is :%@", dicOfPostCodes);
    NSString *tmpPostCode = [dicOfPostCodes valueForKey:PCODE] ;
//    //make it uppercase and save it
//    [dicOfPostCodes setObject:tmpPostCode forKey:PCODE];
    NSString *tmpRef = [dicOfPostCodes valueForKey:REF];
    NSString *tmpHouseNumber=[NSString stringWithFormat:@"%@", [self.dicOfPostCodes valueForKey:HOUSENO]];
    int tmpHouseNumberAsInt= [[self.dicOfPostCodes valueForKey:HOUSENO] intValue];

    NSString *tmpNotes = [dicOfPostCodes valueForKey:NOTES];
    
    NSMutableString *errorString = [[[NSMutableString alloc] init] autorelease];
    
    //validate the input
    if ( ![Validators validPostCode:tmpPostCode error:errorString]) {
        [self errorScreen:errorString];
        return;
    }
 
    if ( ![Validators validReference:tmpRef error:errorString]) {
        [self errorScreen:errorString];
        return;
    }
    
    if (![Validators isEmpty: tmpHouseNumber]){
        //check for housenumber range only if it is not empty
        if ( ![Validators validHouseNumber:tmpHouseNumber error:errorString   ]) {
            [self errorScreen:errorString];
            return;
        }
    }
    
    if ( ( [tmpPostCode hasPrefix:@" "] ) ||  ([tmpPostCode hasSuffix:@" "]) ){
        //[dicOfPostCodes removeObjectForKey:PCODE];
        [dicOfPostCodes setObject:[self trimWhitespace:tmpPostCode] forKey:PCODE];
        tmpPostCode = [dicOfPostCodes valueForKey:@"PostCode"];
    }


    //NSLog(@"The trimmed string :%@:", [self trimWhitespace:[dicOfPostCodes valueForKey:@"PostCode"]]);
    if (isInvokedToAdd) {
        
        [self setEditing:NO animated:YES];
       // [self insertPostCode];
        [self insertPostCode:tmpPostCode Reference:tmpRef HouseNumber:tmpHouseNumberAsInt Notes:tmpNotes];

        //[self populateArrayFromTables];
        self.title=@"Address";
        self.isInvokedToAdd=NO;
        
    } else {
        [self setEditing:NO animated:YES];
        //[self updatePostCode];
        [self updatePostCode:tmpPostCode Reference:tmpRef HouseNumber:tmpHouseNumberAsInt Notes:tmpNotes];
    }
    //updating the orginal copy
    self.dicOfPostCodesBackUp=[[self.dicOfPostCodes mutableCopy] autorelease] ;
    //ToDo: Do we really reloadData. everything working as expected withot trailling/following spaces.
    [self.tableView reloadData];
}

//validators
//-(BOOL) isEmpty:(NSString *) theString {
//    if ([theString length] == 0)
//        return YES;
//    else { //check for blankSpace
//        NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//        NSString *trimmedString= [theString stringByTrimmingCharactersInSet:whiteSpace];
//        return ( [trimmedString isEqualToString:@""]);
//    }
//}

- (void)cancel
{
    if (isInvokedToAdd) {
        [self setEditing:NO animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        self.dicOfPostCodes=[[self.dicOfPostCodesBackUp mutableCopy] autorelease];
        [self setEditing:NO animated:YES];
        [self.tableView reloadData];
        //[self setEditing:NO animated:YES];
    }
}

-(void) displayAlert:(NSString *)title Message:(NSString *)message {
    
    UIAlertView *tmpAlert = [[UIAlertView alloc]
                             initWithTitle:title
                             message:message
                             delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:@"Ok", nil];
    
    [tmpAlert show];
    [tmpAlert autorelease];
    
}

-(void) updatePostCode:(NSString *) postCode Reference:(NSString *) reference HouseNumber:(int) houseNumber Notes:(NSString *) notes {
    
    NSError *error;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entityDescription = [NSEntityDescription
                                              entityForName:@"PostCodes"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    //NSLog(@"PostCode is :%@",[self.dicOfPostCodes objectForKey:PCODE]);
    NSPredicate *selectedPosCode=[NSPredicate predicateWithFormat:@"postCode == %@",
                                  [self.dicOfPostCodesBackUp objectForKey:PCODE]];
    
//  //  NSPredicate *selectedPosCode=[NSPredicate predicateWithFormat:@"postCode == %@",
//                                  postCode];

    [fetchRequest setPredicate:selectedPosCode];

    NSMutableArray *tmpPosCodArray=[[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSLog(@"tmpPosCodArray:%@", tmpPosCodArray);
    
    PostCodes *tmpPosCode = (PostCodes *)[tmpPosCodArray objectAtIndex:0];
    
//    [tmpPosCode setPostCode:[self.dicOfPostCodes objectForKey:PCODE]];
//    [tmpPosCode setReference:[self.dicOfPostCodes objectForKey:REF]];
//    [tmpPosCode setHouseNumber:[NSNumber numberWithInt:[[self.dicOfPostCodes objectForKey:HOUSENO] intValue]]];
//    [tmpPosCode setNotes:[self.dicOfPostCodes objectForKey:NOTES]];
    
    [tmpPosCode setPostCode:postCode];
    [tmpPosCode setReference:reference];
    [tmpPosCode setHouseNumber:[NSNumber numberWithInt:houseNumber]];
    [tmpPosCode setNotes:notes];


    NSError *savingErrorTeams;
    if (![self.managedObjectContext save:&savingErrorTeams]) {
        NSLog(@"Error Saving the PostCode details: %@",[savingErrorTeams description]);
    }
    [fetchRequest release];
    [tmpPosCodArray release];
}

-(void) insertPostCode:(NSString *) postCode Reference:(NSString *) reference HouseNumber:(int) houseNumber Notes:(NSString *) notes {
    
    PostCodes *newPostCode = [NSEntityDescription
                              insertNewObjectForEntityForName:@"PostCodes" inManagedObjectContext:self.managedObjectContext];
    if (newPostCode == nil) {
        NSLog(@"Failed to create a new PostCode");
        return;
    }
//    [newPostCode setPostCode:[self.dicOfPostCodes objectForKey:PCODE]];
//    [newPostCode setReference:[self.dicOfPostCodes objectForKey:REF]];
//    [newPostCode setHouseNumber:[NSNumber numberWithInt:
//                                 [[self.dicOfPostCodes objectForKey:HOUSENO] intValue]]];
//    [newPostCode setNotes:[self.dicOfPostCodes objectForKey:NOTES]];
    
    [newPostCode setPostCode:postCode];
    [newPostCode setReference:reference];
    [newPostCode setHouseNumber:[NSNumber numberWithInt:houseNumber]];
    [newPostCode setNotes:notes];

    NSError *savingError=nil;
    
    if (![self.managedObjectContext save:&savingError]) {
        NSLog(@"Failed to save the post code : Error is :%@", savingError);
        return;
    }

}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    NSString *key = [self getKeyForTag:textField.tag];
    //this check to get the original undisturbed when cancel is pressed
     //NSLog(@"didEndEditing before: dic is :%@", dicOfPostCodes);
    if (self.editing) {
        if (![Validators isEmpty:key]) {
            if ([textField.text length] == 0) {
                //remove the entry from the array if it is empty
                [dicOfPostCodes removeObjectForKey:key];
            } else {
                if (dicOfPostCodes == nil) {
                    //NSLog(@"dic is nil");
                    dicOfPostCodes= [[NSMutableDictionary alloc]init] ;
                }

                if (key == HOUSENO)
                    [dicOfPostCodes setObject:[NSNumber numberWithInt:textField.text.intValue] forKey:key];
                else
                    [dicOfPostCodes setObject:textField.text forKey:key];
            }
        }
    }
    //NSLog(@"didEndEditing after: dic is :%@", dicOfPostCodes);

    [textField setTextColor:[UIColor lightGrayColor]];
    
}

-(void) textFieldDidBeginEditing:(UITextField *)textField   {
    [textField setTextColor:[UIColor darkGrayColor]];
}

-(NSString *) getKeyForTag:(int) tag {
    
    NSString *key=nil;
    //NSLog(@"Tag is :%d", tag)   ;
    switch (tag) {
        case PCODETAG:
            key = PCODE;
            break;
        case REFTAG:
            key =REF;
            break;
        case HOUSENOTAG:
            key=HOUSENO;
            break;
        case NOTESTAG:
            //NSLog(@"ADDR Tag:%d", tag);
            break;
        default:
            NSLog(@"PANIC: tag is not matching.some serious issue:%d", tag);
            break;
    }
    
    return key;

}

-(void) textViewDidEndEditing:(UITextView *)textView {
    //this check to get the original undisturbed when cancel is pressed
    if (self.editing) {
        if ( ![textView.text length] == 0) 
            if (textView.tag==NOTESTAG)
                [dicOfPostCodes setObject:textView.text forKey:NOTES];
    }

    textView.textColor = [UIColor lightGrayColor];
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
     textView.textColor=[UIColor darkGrayColor];
}

//http://stackoverflow.com/questions/3200521/cocoa-trim-all-leading-whitespace-from-nsstring

- (NSString *)trimWhitespace:(NSString *) tmpString {
    NSMutableString *mStr = [tmpString mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
    NSString *result = [mStr copy];
    [mStr release];
    return [result autorelease];
}


-(void)errorScreen:(NSString *)errorString {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Save" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

// Test Username
//if(![CanopyValidator validUsername:[(DetailTextField *)[textFields objectAtIndex:kUsernameIndex] text] error:errorString]) {
//    if (textFieldBeingEdited && index == kUsernameIndex)
//        [self errorField:textFieldBeingEdited valid:FALSE];
//    
//    [self errorScreen:errorString];
//    return TRUE;
//}
//
//// Test Password
//if(![CanopyValidator validPassword:[(DetailTextField *)[textFields objectAtIndex:kPasswordIndex] text] error:errorString]) {
//    if (textFieldBeingEdited && index == kPasswordIndex)
//        [self errorField:textFieldBeingEdited valid:FALSE];
//    
//    [self errorScreen:errorString];
//    return TRUE;
//}
//

- (void)dealloc
{
    [cancelButton release];
    [saveButton release];
    [backButton release];
    [super dealloc];
}


@end
