//
//  editPostCode.m
//  PosCodBook
//
//  Created by Ramesh on 09/10/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import "editPostCode.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "PostCodes.h"
#import <QuartzCore/QuartzCore.h>
#define kOFFSET_FOR_KEYBOARD 185.0

@interface editPostCode ()

@end

@implementation editPostCode
@synthesize managedObjectContext;
@synthesize posCodArray;
@synthesize posCodeFromMainView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Address"];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    //getting singleton managedObjectContext
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;

    UIBarButtonItem *doneBarButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndPushEditViewController)];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [doneBarButton release];
    
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Not needed" style:UIBarButtonItemStylePlain target:nil action:nil];
//   // self.navigationItem.backBarButtonItem=backButton;
//    [backButton release];
    
    
//    UIBarButtonItem *cancelBarButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(pushBackToMainController)];
//    
//    self.navigationItem.leftBarButtonItem = cancelBarButton;
//    [cancelBarButton release];
    

	// Do any additional setup after loading the view.
    [self layingOutControls];
    
   // [self setUpDatabaseQueryEngine];
        
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //NSLog(@"PostCode obj from main view:%@", self.posCodeFromMainView);
    
    [self populateDataWithEditDisabled];
    [self disableEdit];
    
    //NSLog(@"Array from main view controller :%@", self.posCodArray);
}

-(void) populateDataWithEditDisabled {
    
    posCode.text=posCodeFromMainView.postCode;
    reference.text=posCodeFromMainView.reference;
    houseNo.text=posCodeFromMainView.houseNumber.stringValue;
    //notes.text=posCodeFromMainView.address;

}

-(void) disableEdit {
    
    posCode.enabled=NO;
    reference.enabled=NO;
    houseNo.enabled=NO;
    [address setEditable:NO];
    

    
}

-(void) enableEdit {
    posCode.enabled=YES;
    reference.enabled=YES;
    houseNo.enabled=YES;
    [address setEditable:YES];
 
}

-(void) viewWillDisappear:(BOOL)animated {
    
    //clear out the texts and dismiss the keyboard to make it for fresh avaialble when view appears next time
//    posCode.text=@"";
//    reference.text=@"";
//    houseNo.text=@"";
//    address.text=@"";
//    [self dismissKeyboard];

}
-(void) dismissKeyboard {
    
//    if ( [posCode isFirstResponder])
//        [posCode resignFirstResponder];
//    else if ( [reference isFirstResponder])
//        [reference resignFirstResponder];
//    else if ( [houseNo isFirstResponder])
//        [houseNo resignFirstResponder];
//    else if( [address isFirstResponder])
//        [address resignFirstResponder];

}
-(void) layingOutControls {
    
    [self populateLabels];
    [self populateTexts];
}

-(void) populateLabels {
    
    UILabel *posLabel =[self createLabel:0 Top:30 Width:130 Height:40 Tag:0
                                txtColor:[UIColor blueColor] Font:[UIFont fontWithName:@"Helvetica" size:20] Text:@"PostCode" Align:1 ];
    
    [self.view addSubview:posLabel];
    
    UILabel *refLabel =[self createLabel:0 Top:100 Width:130 Height:40 Tag:1
                                txtColor:[UIColor blueColor] Font:[UIFont fontWithName:@"Helvetica" size:20] Text:@"Reference" Align:1 ];
    
    [self.view addSubview:refLabel];
    
    
    UILabel *houseNoLabel =[self createLabel:10 Top:170 Width:150 Height:40 Tag:2
                                    txtColor:[UIColor blueColor] Font:[UIFont fontWithName:@"Helvetica" size:20] Text:@"HouseNumber" Align:1 ];
    
    [self.view addSubview:houseNoLabel];
    
    
    UILabel *addressLabel =[self createLabel:0 Top:240 Width:110 Height:40 Tag:3
                                    txtColor:[UIColor blueColor] Font:[UIFont fontWithName:@"Helvetica" size:20] Text:@"Address" Align:1 ];
    
    [self.view addSubview:addressLabel];

    
}

-(void) populateTexts {
    
    posCode =[self createText:100 Top:70 Width:150 Height:30 Tag:4 Color:[UIColor whiteColor] Font:[UIFont fontWithName:@"Helvetica" size:20] BorderStyle:UITextBorderStyleRoundedRect
                                  Keyboard:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyDone];
    
    [self.view addSubview:posCode];
    posCode.delegate=self;
    
    reference =[self createText:100 Top:140 Width:150 Height:30 Tag:4 Color:[UIColor whiteColor] Font:[UIFont fontWithName:@"Helvetica" size:20] BorderStyle:UITextBorderStyleRoundedRect
                                    Keyboard:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyDone];
    
    [self.view addSubview:reference];
    
    
    houseNo =[self createText:100 Top:210 Width:150 Height:30 Tag:4 Color:[UIColor whiteColor] Font:[UIFont fontWithName:@"Helvetica" size:20] BorderStyle:UITextBorderStyleRoundedRect
                                  Keyboard:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyDone];
    
    [self.view addSubview:houseNo];
    
    
    address= [[UITextView alloc] initWithFrame:CGRectMake(100, 275, 180, 135)];
    address.font= [UIFont fontWithName:@"Helvetica" size:20];
    
    //To make the border look very close to a UITextField - need to import Quartzcore
    
    [address.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [address.layer setBorderWidth:3.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    address.layer.cornerRadius = 5;
    address.clipsToBounds = YES;
    address.delegate =self;
    
    [self.view addSubview:address];

}

-(BOOL) insertPostCode {

    PostCodes *newPostCode = [NSEntityDescription
                              insertNewObjectForEntityForName:@"PostCodes" inManagedObjectContext:self.managedObjectContext];
    if (newPostCode == nil) {
        NSLog(@"Failed to create a new PostCode");
        return NO;
    }
    
    newPostCode.postCode=posCode.text;
    newPostCode.reference=reference.text;
    newPostCode.houseNumber=[NSNumber numberWithInteger:houseNo.text.intValue];
    newPostCode.notes=address.text;
    
    NSError *savingError=nil;
    
    if ([self.managedObjectContext save:&savingError]) {
        NSLog(@"Record saved");
        
        return YES;
    } else {
        NSLog(@"Failed to save the post code : Error is :%@", savingError);
        return NO;
    }
}
//core data fns : we are going to initialize an NSFetchRequest object and set some properties for it. Then we’ll initialize the fetchedResultsController object.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel *) createLabel:(float)left Top:(float)top Width:(float)width Height:(float)height Tag:(int) tag
                   txtColor:(UIColor *) txtColor Font:(UIFont *) font Text:(NSString *) text Align:(NSTextAlignment) align {
    
    //UILabel *runCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(121, 6, 30, 20)];
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, width, height)];
    [tmpLabel setTag:tag];
    [tmpLabel setBackgroundColor:[UIColor clearColor]];
    [tmpLabel setTextColor:txtColor];
    [tmpLabel setFont:font];
    [tmpLabel setTextAlignment:align];
    [tmpLabel setText:text];
    
    return tmpLabel;
    
}

-(UITextField *) createText:(float)left Top:(float)top Width:(float)width Height:(float)height Tag:(int) tag
                      Color:(UIColor *) color Font:(UIFont *) font BorderStyle:(UITextBorderStyle) borderStyle Keyboard:(UIKeyboardType) keyBoardType ReturnKeyType:(UIKeyboardType) keyBoardReturn {
    
    UITextField *tmpTxt = [[UITextField alloc] initWithFrame:CGRectMake(left, top, width, height)];
    [tmpTxt setTag:tag];
    [tmpTxt setFont:font];
    [tmpTxt setBackgroundColor:color];
    [tmpTxt setBorderStyle:borderStyle];
    [tmpTxt setKeyboardType:keyBoardType];
    [tmpTxt setReturnKeyType:keyBoardReturn];
    [tmpTxt setDelegate:self];
    
    return [tmpTxt autorelease];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
       
    if ([textField isEqual:houseNo] )
    {
        // NSLog(@" didEnd origin of y:%f", self.view.frame.origin.y );
        //move the main view back
        if (self.view.frame.origin.y < 0) {
            
            [self setViewMovedUp:NO];
            
        }
    }
    [textField resignFirstResponder];
    return YES;
}

-(void) pushBackToMainController {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) saveAndPushEditViewController {
    
    if ( [self isEmpty:posCode]) {
        
        [self displayAlert:@"No PostCode" Message:@"PostCode can not be empty"];
        return;
    } else if  ( [self isEmpty:reference]) {
        
        [self displayAlert:@"No Reference" Message:@"Reference can not be empty"];
        return;
    }
    
    if ( [self isDuplicate]) {
        [self displayAlert:@"Duplicate" Message:@"PostCode or Reference already exists"];
    }

    [self updatePosCodRecordes];
    
}

-(void) updatePosCodRecordes {
    
    NSError *error;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entityDescription = [NSEntityDescription
                                              entityForName:@"PostCodes"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *selectedPosCode=[NSPredicate predicateWithFormat:@"postCode == %@",
                                 self.posCodeFromMainView.postCode];
    [fetchRequest setPredicate:selectedPosCode];
    
    NSMutableArray *tmpPosCodArray=[[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    PostCodes *tmpPosCode = (PostCodes *)[tmpPosCodArray objectAtIndex:0];
    [tmpPosCode setPostCode:posCode.text];
    [tmpPosCode setReference:reference.text];
    [tmpPosCode setHouseNumber:[NSNumber numberWithInt:houseNo.text.intValue]];
    [tmpPosCode setAddress:address.text];
    
    NSError *savingErrorTeams;
    if (![self.managedObjectContext save:&savingErrorTeams]) {
        NSLog(@"Error Saving the PostCode details: %@",[savingErrorTeams description]);
    }

}

-(BOOL) isDuplicate {
    
    //NSLog(@"Actual Index:%d", self.posCodeRecordIndex );

    
    for (int i=0; i< [self.posCodArray count]; i++) {
        
        PostCodes *postCode = (PostCodes*) [self.posCodArray objectAtIndex:i];
       // NSLog(@"Current Index:%d Actual Value:%@", i,postCode.postCode);
        
        if  ([posCode.text isEqualToString:postCode.postCode] ||
             [reference.text isEqualToString:postCode.reference] ) {
            
//            if  ( ( [posCode.text isEqualToString:postCode.postCode] &&
//                   [houseNo.text isEqualToString:(NSString *)postCode.houseNumber.stringValue]
//                   )
//                 ||
//                 [reference.text isEqualToString:postCode.reference] )
            
            //NSLog(@"Matched Index:%d Actual Index:%d", i, self.posCodeRecordIndex );
            //if it is the same record
            if (self.posCodeRecordIndex == i) {
               // NSLog(@"Matched: Indexes are the same");
                return FALSE;
            }
            
            
            return TRUE;
        }
    } //for
    
        return FALSE;
        
}
    
//-(void) textFieldDidEndEditing:(UITextField *)sender {
//    
//    if ([sender isEqual:address] ) 
//    {
//        // NSLog(@" didEnd origin of y:%f", self.view.frame.origin.y );
//        //move the main view back
//        if (self.view.frame.origin.y < 0) {
//        
//        [self setViewMovedUp:NO];
//            [sender resignFirstResponder];
//            
//        }
//        
//    }
//
//}

-(BOOL) textViewShouldReturn:(UITextView*) textView {
    [textView resignFirstResponder];
    return YES ;
}

-(void) textViewDidEndEditing:(UITextView *)sender {
    
    //    if ([sender isEqual:address] )
    //    {
    //        // NSLog(@" didEnd origin of y:%f", self.view.frame.origin.y );
    //        //move the main view back
    //        if (self.view.frame.origin.y < 0) {
    //
    //            [self setViewMovedUp:NO];
    //            [sender resignFirstResponder];
    //
    //        }
    //
    //    }
    //
    [sender resignFirstResponder];
    
}


-(void)textFieldDidBeginEditing:(UITextField *)sender
{
   
    if ([sender isEqual:houseNo] ) 
    {
        
        //NSLog(@" did Beginorigin of y:%f", self.view.frame.origin.y );
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        
    }
}

-(void)textViewDidBeginEditing:(UITextView *)sender
{
    
    // NSLog(@" textView: did Beginorigin of y:%3f", self.view.frame.origin.y );
    
    if ([sender isEqual:address] )
    {
        //NSLog(@" did Beginorigin of y:%f", self.view.frame.origin.y );
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
            //NSLog(@" textView: after moving the view in textView y:%3f", self.view.frame.origin.y );
        }
        
    }
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ( [text isEqualToString:@"\n"]) {
        [self setViewMovedUp:NO];
        [textView resignFirstResponder];
        return  NO;
    }
    
    return YES;
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

//validators

-(BOOL) isEmpty:(UITextField *) textField {
    if (textField.text == nil || [textField.text isEqualToString:@""])
        return YES  ;
    else { //check for blankSpace
        NSString *tmpString = textField.text;
        NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmedString= [tmpString stringByTrimmingCharactersInSet:whiteSpace];
        return ( [trimmedString isEqualToString:@""]);
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

-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    
    
     [super setEditing:editing animated:animated];
    
    if (editing == YES) {
        
        //change the views to edit mode
        
        [self enableEdit];
        
        //not needed. by default the "done" button will be displayed
        
//        UIBarButtonItem *doneBarButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndPushEditViewController)];
//        
//        self.navigationItem.rightBarButtonItem = doneBarButton;
//        [doneBarButton release];
        
        [self.navigationItem setHidesBackButton:YES];
        
//        
        UIBarButtonItem *cancelBarButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit)];

        self.navigationItem.leftBarButtonItem = cancelBarButton;
        [cancelBarButton release];
        
        isCancelBtn=NO;
        
       //self.navigationItem.backBarButtonItem = nil;

    } else { //called this part when Done/Cancel is pressed.
        
        //save the changes if needed and change the views to noneditable
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem setHidesBackButton:NO];
        [self disableEdit];
        //NSLog(@" view's y:%3f", self.view.frame.origin.y );
        if ( self.view.frame.origin.y != 0) {
           // NSLog(@"The cancel/done btn tapped when keyboard displaed in houseNo/address. So move the view up. ");
            [self setViewMovedUp:NO];
        }
        //call savefn only if cancel button not pressed.
        if (!isCancelBtn) {
            [self saveAndPushEditViewController];
            [self disableEdit];
        }
        isCancelBtn=NO;
//        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Not needed" style:UIBarButtonItemStylePlain target:nil action:nil];
//        self.navigationItem.backBarButtonItem=backButton;
//        [backButton release];

               
    }
}

-(void) cancelEdit {
    
    isCancelBtn=YES;
    //NSLog(@"inside cacelEdit");
    [self populateDataWithEditDisabled];
//    self.navigationItem.rightBarButtonItem = nil;
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setEditing:NO animated:NO];

    
}

		
@end
