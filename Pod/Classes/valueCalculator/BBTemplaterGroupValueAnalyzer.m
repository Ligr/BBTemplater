//
//  BBTemplaterGroupValueAnalyzer.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 8/17/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterGroupValueAnalyzer.h"

#import "BBTemplaterStringUtils.h"
#import "BBTemplaterContext.h"

@implementation BBTemplaterGroupValueAnalyzer

- (NSString *)valueForKey:(NSString *)key inContext:(BBTemplaterContext *)context {
	NSString *result = nil;
	NSNumber *arrayIndex = [BBTemplaterStringUtils extrackIndexFromString:key];
	if ([key hasPrefix:@"group."] && (arrayIndex || [key isEqualToString:@"group.length"])) {
		id data = [context searchGroup];
		if (arrayIndex) {
			if ([data isKindOfClass:[NSArray class]]) {
				NSArray *dataArr = (NSArray *)data;
				if (dataArr.count > [arrayIndex integerValue]) {
					result = dataArr[[arrayIndex integerValue]];
				} else {
					NSLog(@"'%@' is out of bounds", key);
				}
			} else if ([arrayIndex integerValue] == 0) {
				result = data;
			} else {
				NSLog(@"can't get '%@' because data is not an array", key);
			}
		} else {
			if ([data isKindOfClass:[NSArray class]]) {
				NSArray *dataArr = (NSArray *)data;
				result = [NSString stringWithFormat:@"%@", @(dataArr.count)];
			} else {
				result = @"1";
			}
		}
	}
	return result;
}

@end
