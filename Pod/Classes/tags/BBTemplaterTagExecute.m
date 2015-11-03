//
//  BBTemplaterTagExecute.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 7/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagExecute.h"

@implementation BBTemplaterTagExecute

+ (NSString *)tagName {
	return @"execute";
}

- (void)process:(void (^)(id, NSError *))callback {
	NSString *value = self.value;
	if (value) {
		BBTemplaterTag *callbackTag = [self.context callbackForName:value];
		if (callbackTag) {
			[callbackTag process:^(id data, NSError *error) {
				callback(data, error);
			}];
		} else {
			NSLog(@"[BBTemplaterTagExecute][ERROR]: callback with name '%@'", value);
		}
	} else {
		NSLog(@"[BBTemplaterTagExecute][ERROR]: missing attribute 'value'");
	}
}

@end
