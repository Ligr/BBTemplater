//
//  BBTemplaterValueAnalyzer.h
//  BalanceBy
//
//  Created by Alex on 8/6/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBTemplaterContext;

@protocol BBTemplaterValueAnalyzer <NSObject>

- (NSString *)valueForKey:(NSString *)key inContext:(BBTemplaterContext *)context;

@end
