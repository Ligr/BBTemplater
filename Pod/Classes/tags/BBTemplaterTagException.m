//
//  BBTemplaterTagException.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 8/10/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagException.h"

#import "BBTemplaterErrors.h"

@implementation BBTemplaterTagException

+ (NSString *)tagName {
	return @"exception";
}

- (void)process:(void (^)(id, NSError *))callback {
	NSString *value = self.value;
	NSError *error = nil;
	if (!value) {
		error = [BBTemplaterErrors missingAttributeError:@"<exception>: 'value' is required"];
	} else {
		error = [BBTemplaterErrors genericError:value];
	}
	callback(nil, error);
}

@end
