//
//  BBTemplaterFunctionValueAnalyzer.m
//  Pods
//
//  Created by Alex on 3/28/16.
//
//

#import "BBTemplaterFunctionValueAnalyzer.h"

@implementation BBTemplaterFunctionValueAnalyzer

- (NSString *)valueForKey:(NSString *)key inContext:(BBTemplaterContext *)context {
	NSString *result = nil;
	if ([key hasPrefix:@"function."]) {
		if ([key hasSuffix:@".time"]) {
			result = [NSString stringWithFormat:@"%@", @([[NSDate date] timeIntervalSince1970])];
		}
	}
	return result;
}

@end
