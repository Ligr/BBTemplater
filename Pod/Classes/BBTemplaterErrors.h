//
//  BBTemplaterErrors.h
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BB_ERROR_DOMAIN @"BBTemplaterError"
#define BB_EC_MISSING_ATTRIBUTE 1
#define BB_EC_UNSUPPORTED_REQUEST_TYPE 2
#define BB_EC_INVALID_FORMAT 3
#define BB_EC_INVALID_PARAMETER 4
#define BB_EC_GENERIC 5
#define BB_EC_REQUIRED_DATA_MISSING 6

@interface BBTemplaterErrors : NSObject

+ (NSError *)missingAttributeError:(NSString *)attributeName;
+ (NSError *)unsupporterRequestTypeError:(NSString *)requestType;
+ (NSError *)invalidFormatError:(NSString *)message;
+ (NSError *)invalidParameterError:(NSString *)message;
+ (NSError *)genericError:(NSString *)message;
+ (NSError *)requiredDataIsMissing:(NSString *)message;

@end
