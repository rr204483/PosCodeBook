//
//  Validators.h
//  PosCodBook
//
//  Created by Ramesh on 14/11/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Validators : NSObject

+(BOOL)isEmpty:(NSString *)string;
+(BOOL)emptyOrWhiteSpace:(NSString *)string error:(NSMutableString *)errorString;
+(BOOL)validPostCode:(NSString *)postCode error:(NSMutableString *)errorString;
+(BOOL)validReference:(NSString *)reference error:(NSMutableString *)errorString;
+(BOOL)validHouseNumber:(NSString *)housenumber error:(NSMutableString *)errorString;


@end
