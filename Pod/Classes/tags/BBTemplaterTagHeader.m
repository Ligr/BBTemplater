//
//  BBTemplaterTagHeader.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagHeader.h"

@implementation BBTemplaterTagHeader

+ (NSString *)tagName {
	return @"header";
}

- (NSString *)name {
	NSString *name = self.attributes[@"name"];
#if DEBUG
	if (!name) {
		NSLog(@"[BBTemplaterTagHeader][ERROR]: missing attribute 'name'");
	}
#endif
	return name;
}

- (NSString *)value {
	NSString *value = super.value;
#if DEBUG
	if (!value) {
		NSLog(@"[BBTemplaterTagHeader][ERROR]: missing attribute 'value'");
	}
#endif
	return value;
}

@end
