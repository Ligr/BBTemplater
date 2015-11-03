//
//  BBTemplaterTagParam.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagParam.h"

@implementation BBTemplaterTagParam

+ (NSString *)tagName {
	return @"param";
}

- (NSString *)name {
	NSString *name = self.attributes[@"name"];
#if DEBUG
	if (!name) {
		NSLog(@"[BBTemplaterTagParam][ERROR]: missing attribute 'name'");
	}
#endif
	return name;
}

- (NSString *)value {
	NSString *value = super.value;
#if DEBUG
	if (!value) {
		NSLog(@"[BBTemplaterTagParam][ERROR]: missing attribute 'value'");
	}
#endif
	return value;
}

- (BOOL)includeHidden {
	BOOL include = NO;
	if (self.attributes[@"include"] && [self.attributes[@"include"] isEqualToString:@"hidden"]) {
		include = YES;
	}
	return include;
}

@end
