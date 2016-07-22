//
//  Validators.m
//  PosCodBook
//
//  Created by Ramesh on 14/11/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import "Validators.h"

#define PCODELENGTH 15
#define MAXHOUSENUMBER 1000


@implementation Validators

+(BOOL)isEmpty:(NSString *)string {
    
    if(!string) {
        return TRUE;
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [string stringByTrimmingCharactersInSet:whitespace];
    
    // Make sure it's not just whitespace
    if([trimmed length] == 0) {
        return TRUE;
    }
    
    return FALSE;
}

/*
 * Verify string is neither empty nor contains whitespace
 */
+(BOOL)emptyOrWhiteSpace:(NSString *)string error:(NSMutableString *)errorString {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    if([self isEmpty:string]) {
        [errorString setString:@"is empty"];
        return TRUE;
    }
    
    /* Check for the existence of whitespace */
    NSRange range = [string rangeOfCharacterFromSet:whitespace];
    if (range.location != NSNotFound) {
        return TRUE;
        [errorString setString:@"contains whitespace"];
    }
    
    return FALSE;
}

/*
 * Verify string is a valid postCode
 */
+(BOOL)validPostCode:(NSString *)postCode error:(NSMutableString *)errorString {
    if([self isEmpty:postCode]) {
        [errorString setString:@"Postcode is empty"];
        return FALSE;
    }
    
    //checking for valid name
    
    if ([postCode length] > PCODELENGTH ) {
        [errorString setString:
         @"Postcode: Cannot be greater than 10 characters"];
        return FALSE;
    }
    
//    NSMutableCharacterSet *legalCharSet =
//    [NSCharacterSet alphanumericCharacterSet];
//    [legalCharSet addCharactersInString:@"-."];
//    
//    NSString *tmpString = [ self trimWhitespace:[postCode stringByTrimmingCharactersInSet:legalCharSet] ];
//    
//   // NSLog(@"valid postCode:p %@ p %@ p", [postCode stringByTrimmingCharactersInSet:legalCharSet], tmpString);
//    if  ( ([tmpString isEqualToString:@""] == FALSE) &&
//          (![self emptyOrWhiteSpace:tmpString error:nil] )
//         )
//    {
//        [errorString setString:
//         @"Postcode: Can only contain alphanumeric characters plus _ and ."];
//        return FALSE;
//    }
    
    return TRUE;
}

/*
 * Verify string is a valid reference
 */
+(BOOL)validReference:(NSString *)reference error:(NSMutableString *)errorString {
    if([self isEmpty:reference]) {
        [errorString setString:@"Reference is empty"];
        return FALSE;
    }
    
    return TRUE;
}

+(BOOL) validHouseNumber:(NSString *)housenumber error:(NSMutableString *)errorString {
    
    int housenumberAsInt = [housenumber intValue];
    
//    //Housenumber can be empty
//    if([self isEmpty:housenumber]) {
//        return TRUE;
//    }

    if ( housenumberAsInt < 0) {
        [errorString setString:
         @"HouseNumber:  Houser number is Invalid"];
        return FALSE;
    }
    
    if ( housenumberAsInt > MAXHOUSENUMBER ) {
        [errorString setString:
         @"HouseNumber:  Cannot be greater than 1000"];
        return FALSE;
    }
    
    return TRUE;

}

+ (NSString *)trimWhitespace:(NSString *) tmpString {
    NSMutableString *mStr = [tmpString mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
    NSString *result = [mStr copy];
    [mStr release];
    return [result autorelease];
}



@end
