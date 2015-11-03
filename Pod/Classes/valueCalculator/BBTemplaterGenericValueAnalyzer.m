//
//  BBTemplaterGenericValueAnalyzer.m
//  BalanceBy
//
//  Created by Alex on 8/6/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterGenericValueAnalyzer.h"

#import "BBTemplaterStringUtils.h"

@implementation BBTemplaterGenericValueAnalyzer

- (NSString *)valueForKey:(NSString *)key inContext:(BBTemplaterContext *)context {
	NSNumber *arrayIndex = [BBTemplaterStringUtils extrackIndexFromString:key];
	// remove index from key
	if (arrayIndex) {
		NSRange dotRange = [key rangeOfString:@"." options:NSBackwardsSearch];
		key = [key substringToIndex:dotRange.location];
	}
	id value = [context storedValueForKey:key];
	if (value && arrayIndex && [value isKindOfClass:[NSArray class]] && [(NSArray *)value count] > [arrayIndex integerValue]) {
		value = value[[arrayIndex integerValue]];
	}
	return [value isKindOfClass:[NSString class]] ? value : nil;
}

@end
