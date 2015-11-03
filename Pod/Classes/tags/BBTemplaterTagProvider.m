//
//  BBTemplaterTagProvider.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagProvider.h"

#import "BBTemplaterErrors.h"

@implementation BBTemplaterTagProvider

+ (NSString *)tagName {
	return @"provider";
}

#pragma mark - Private

- (void)process:(void(^)(id data, NSError *error))callback {
	NSString *data = [self.context data];
	NSError *error = nil;
	NSString *url = self.attributes[@"url"];
	if (url) {
		[self.context storeValue:url forKey:@"provider.url"];
	} else {
		error = [BBTemplaterErrors missingAttributeError:@"url"];
	}
	callback(data, error);
}

@end
