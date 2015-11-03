//
//  BBTemplaterTagValue.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/30/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagVar.h"

#import "BBTemplaterFunctions.h"

@implementation BBTemplaterTagVar

+ (NSString *)tagName {
	return @"var";
}

- (NSString *)name {
	NSString *name = self.attributes[@"name"];
#if DEBUG
	if (!name) {
		NSLog(@"[BBTemplaterTagValue][ERROR]: missing attribute 'name'");
	}
#endif
	return name;
}

#pragma mark - Private

- (void)process:(void(^)(id data, NSError *error))callback {
	NSString *data = [self.context data];
	NSString *value = self.value ? : data;
	NSError *error = nil;
	if (self.function) {
		value = [BBTemplaterFunctions calculateValue:value withFunctionDetails:self.function error:&error];
	}
	[self.context storeValue:value forVariable:self.name];
	callback(value, error);
}

@end
