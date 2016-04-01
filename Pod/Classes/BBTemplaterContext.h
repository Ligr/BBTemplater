//
//  BBTemplaterContext.h
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBTemplaterValueProcessor.h"

#define BB_KEY_BALANCE @"BB_KEY_BALANCE"
#define BB_KEY_PLAN @"BB_KEY_PLAN"

@class BBTemplaterTag;

@interface BBTemplaterContext : NSObject

@property (nonatomic, readonly) NSString *account;
@property (nonatomic, readonly) NSMutableDictionary *regexCache;
@property (nonatomic, assign) NSStringEncoding dataEncoding;

- (id)initWithValueProcessor:(BBTemplaterValueProcessor *)processor;

- (void)storeValue:(id)value forKey:(NSString *)key;
- (void)storeValues:(NSDictionary *)values;
// store in format "var.variable"
- (void)storeValue:(id)value forVariable:(NSString *)variable;
- (void)addValue:(id)value toArrayWithName:(NSString *)arrayName;
- (id)storedValueForKey:(NSString *)key;
- (id)evaluateValue:(NSString *)value;

- (void)pushAccountWithName:(NSString *)name;
- (NSString *)popAccount;

- (void)registerCallback:(BBTemplaterTag *)callback forName:(NSString *)name;
- (BBTemplaterTag *)callbackForName:(NSString *)name;

- (void)outValue:(id)value withName:(NSString *)name;
- (NSArray *)outValuesWithName:(NSString *)name;

- (void)pushData:(id)data;
- (void)popData;
- (id)data;

- (void)pushSearchGroup:(id)data;
- (void)popSearchGroup;
- (id)searchGroup;

@end
