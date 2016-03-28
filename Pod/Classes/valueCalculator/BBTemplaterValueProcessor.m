//
//  BBTemplaterValueCalculator.m
//  BalanceBy
//
//  Created by Alex on 8/6/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterValueProcessor.h"

#import "BBTemplaterGenericValueAnalyzer.h"
#import "BBTemplaterPhoneByValueAnalyzer.h"
#import "BBTemplaterPhoneValueAnalyzer.h"
#import "BBTemplaterResultValueAnalyzer.h"
#import "BBTemplaterGroupValueAnalyzer.h"
#import "BBTemplaterFunctionValueAnalyzer.h"

@interface BBTemplaterValueProcessor () {
	NSArray *_valueAnalyzers;
	NSRegularExpression *_valueRegex;
}

@end

@implementation BBTemplaterValueProcessor

+ (instancetype)instance {
	static BBTemplaterValueProcessor *instalce = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instalce = [BBTemplaterValueProcessor new];
	});
	return instalce;
}

- (NSString *)valueForString:(NSString *)string inContext:(BBTemplaterContext *)context {
	__block NSString *resultString = nil;
	__block BOOL simpleValue = YES;
	if (string != nil) {
		[_valueRegex enumerateMatchesInString:string options:0 range:NSMakeRange(0, [string length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
			simpleValue = NO;
			NSString *expression = [string substringWithRange:match.range];
			NSString *valueKey = [expression substringWithRange:NSMakeRange(2, expression.length - 3)];
			
			NSString *value = [self valueForKey:valueKey inContext:context];
			
			if (value && [value isKindOfClass:[NSString class]]) {
				if (!resultString) {
					resultString = string;
				}
				resultString = [resultString stringByReplacingOccurrencesOfString:expression withString:value options:0 range:NSMakeRange(0, resultString.length)];
			}
		}];
	}
	if (simpleValue) {
		resultString = string;
	}
	return resultString;
}

#pragma mark - Private

- (NSString *)valueForKey:(NSString *)key inContext:(BBTemplaterContext *)context {
	NSString *value = nil;
	for (id<BBTemplaterValueAnalyzer> analyzer in _valueAnalyzers) {
		value = [analyzer valueForKey:key inContext:context];
		if (value) {
			break;
		}
	}
	return value;
}

- (id)init {
	self = [super init];
	if (self) {
		NSMutableArray *analyzers = [NSMutableArray new];
		[analyzers addObject:[BBTemplaterGroupValueAnalyzer new]];
		[analyzers addObject:[BBTemplaterResultValueAnalyzer new]];
		[analyzers addObject:[BBTemplaterPhoneByValueAnalyzer new]];
		[analyzers addObject:[BBTemplaterPhoneValueAnalyzer new]];
		[analyzers addObject:[BBTemplaterGenericValueAnalyzer new]];
		[analyzers addObject:[BBTemplaterFunctionValueAnalyzer new]];
		_valueAnalyzers = analyzers;
		_valueRegex = [NSRegularExpression regularExpressionWithPattern:@"\\$\\{[\\d\\w\\.]*\\}" options:NSRegularExpressionCaseInsensitive error:nil];
	}
	return self;
}

@end
