//
//  BBTemplaterTagSubaccount.m
//  BalanceBy
//
//  Created by Alex on 7/6/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagSubaccount.h"

@implementation BBTemplaterTagSubaccount

+ (NSString *)tagName {
	return @"subaccount";
}

- (NSString *)tagId {
	NSString *tagId = self.attributes[@"id"];
#if DEBUG
	if (!tagId) {
		NSLog(@"[BBTemplaterTagSubaccount][ERROR]: missing attribute 'id'");
	}
#endif
	return tagId;
}

#pragma mark - Private

- (void)process:(void (^)(id, NSError *))callback {
	NSString *name = self.tagId;
	if (name) {
		[self.context pushAccountWithName:name];
	}
	callback(nil, nil);
}

- (void)didEnd {
	[super didEnd];
	[self.context popAccount];
}

@end
