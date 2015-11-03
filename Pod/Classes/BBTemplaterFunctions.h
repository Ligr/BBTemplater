//
//  BBTemplaterFunctions.h
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/30/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTemplaterFunctions : NSObject

+ (NSString *)calculateValue:(id)value withFunctionDetails:(NSString *)functionDetails error:(NSError **)error;

@end
