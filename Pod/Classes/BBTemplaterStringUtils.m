//
//  BBTemplaterStringUtils.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/30/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterStringUtils.h"

#import "BBTemplaterContext.h"

@implementation BBTemplaterStringUtils

+ (NSNumber *)extrackIndexFromString:(NSString *)string {
	NSNumber *index = nil;
	NSRange dotRange = [string rangeOfString:@"." options:NSBackwardsSearch];
	if (dotRange.location != NSNotFound) {
		NSString *lastKey = [string substringFromIndex:dotRange.location + 1];
		NSScanner *scan = [NSScanner scannerWithString:lastKey];
		NSInteger indexInt;
		BOOL indexPresent = [scan scanInteger:&indexInt] && [scan isAtEnd];
		if (indexPresent) {
			index = @(indexInt);
		}
	}
	return index;
}

+ (NSString *)stripHtmlFromString:(NSString *)string {
	NSRange r;
	if ([string isKindOfClass:[NSString class]]) {
		while (string && (r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
			string = [string stringByReplacingCharactersInRange:r withString:@""];
		}
	}
	return string;
}

@end
