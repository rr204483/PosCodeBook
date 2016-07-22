//
//  PostCodes.h
//  PosCodBook
//
//  Created by Ramesh on 06/11/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PostCodes : NSManagedObject

@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * houseNumber;
@property (nonatomic, retain) NSString * postCode;
@property (nonatomic, retain) NSString * reference;

@end
