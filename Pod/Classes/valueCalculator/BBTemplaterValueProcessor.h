//
//  BBTemplaterValueCalculator.h
//  BalanceBy
//
//  Created by Alex on 8/6/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBTemplaterValueAnalyzer.h"

@class BBTemplaterContext;

@interface BBTemplaterValueProcessor : NSObject

- (void)registerValueAnalyzer:(id<BBTemplaterValueAnalyzer>)valueAnalyzer;
- (NSString *)valueForString:(NSString *)string inContext:(BBTemplaterContext *)context;

@end
