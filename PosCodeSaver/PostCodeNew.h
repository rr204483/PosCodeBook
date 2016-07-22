//
//  PostCodeNew.h
//  PosCodBook
//
//  Created by Ramesh on 09/10/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PostCodeNew : UIViewController<UITextFieldDelegate, UITextViewDelegate> {
    UITextField *posCode;
    UITextField *reference;
    UITextField *houseNo;
    UITextView *address;
}

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong) NSFetchedResultsController  *fetchedResultsController;

@property(nonatomic, strong) NSArray *posCodArray;

@end
