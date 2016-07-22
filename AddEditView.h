//
//  TableViewEdit.h
//  PosCodBook
//
//  Created by Ramesh on 25/10/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PostCodes.h"


@interface AddEditView : UITableViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, NSFetchedResultsControllerDelegate> {
     UIBarButtonItem *saveButton;
     UIBarButtonItem *backButton;
     UIBarButtonItem *cancelButton;

}

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, strong) NSArray *posCodArray;
@property(nonatomic, strong) PostCodes *currentPosCodeObj;
@property(nonatomic) int posCodeRecordIndex;

@property (nonatomic) BOOL isInvokedToAdd;

@property(nonatomic, strong) NSMutableDictionary *dicOfPostCodes;

@property(nonatomic, strong) NSMutableDictionary *dicOfPostCodesBackUp;

@end
