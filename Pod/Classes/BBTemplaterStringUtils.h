//
//  BBTemplaterStringUtils.h
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/30/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBTemplaterContext;

@interface BBTemplaterStringUtils : NSObject

+ (NSNumber *)extrackIndexFromString:(NSString *)string;
+ (NSString *)stripHtmlFromString:(NSString *)string;

@end
