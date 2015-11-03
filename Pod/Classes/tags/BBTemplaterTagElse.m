//
//  BBTemplaterTagElse.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 7/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagElse.h"

#import "BBTemplaterTagsProcessor.h"

@implementation BBTemplaterTagElse

+ (NSString *)tagName {
	return @"else";
}

- (void)process:(void (^)(id, NSError *))callback {
	id data = [self.context data];
	BBTemplaterTagsProcessor *processor = [[BBTemplaterTagsProcessor alloc] initWithTags:self.subtags data:data];
	[processor process:^(NSError *error) {
		callback(data, error);
	}];
}

@end
