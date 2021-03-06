//
//  BBTemplater.h
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTemplater : NSObject

- (id)initWithTemplate:(NSString *)templateStr data:(NSString *)data;
- (id)initWithTemplate:(NSString *)templateStr data:(NSString *)data valueAnalyzers:(NSArray *)valueAnalyzers;

- (void)process:(void(^)(NSError *error))callback;
- (void)registerVariables:(NSDictionary *)variables;
- (void)setDataEncoding:(NSStringEncoding)encoding;
- (id)variableForKey:(NSString *)key;
- (NSArray *)outValuesWithName:(NSString *)name;
- (void)registerTag:(Class)tag withName:(NSString *)name;

@end
