//
//  BBTemplaterTag.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTag.h"

#import "BBTemplaterStringUtils.h"
#import "BBTemplaterValueProcessor.h"

@interface BBTemplaterTag () {
	NSMutableArray *_subtags;
	NSDictionary *_attributes;
	BBTemplaterContext *_context;
}

@end

@implementation BBTemplaterTag

+ (NSString *)tagName {
	NSLog(@"[BBTemplaterTag][ERROR]: tag name should be overriden");
	return nil;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes context:(BBTemplaterContext *)context {
	self = [super init];
	if (self) {
		_context = context;
		_attributes = attributes;
		[self tt_setup];
	}
	return self;
}

- (void)addSubtag:(BBTemplaterTag *)tag {
	[_subtags addObject:tag];
}

- (void)process:(void(^)(id data, NSError *error))callback {
	if (callback) {
		callback([_context data], nil);
	}
}

- (BOOL)required {
	return _attributes[@"required"] && [[_attributes[@"required"] lowercaseString] isEqualToString:@"true"];
}

- (NSString *)name {
	NSString *name = self.attributes[@"name"];
	if (name) {
		name = [self.context evaluateValue:name];
	}
	return name;
}

- (NSString *)value {
	NSString *value = self.attributes[@"value"];
	if (value) {
		value = [self.context evaluateValue:value];
	}
	return value;
}

- (NSString *)function {
	NSString *function = self.attributes[@"function"];
	if (function) {
		function = [self.context evaluateValue:function];
	}
	return function;
}

- (NSString *)url {
	NSString *url = self.attributes[@"url"];
	if (url) {
		url = [self.context evaluateValue:url];
	}
	return url;
}

- (void)willStartWithData:(id)data {
	[_context pushData:data];
}

- (void)didEnd {
	[_context popData];
}

- (BOOL)needProcessing {
	return YES;
}

- (BOOL)needSubtagsProcessing {
	return YES;
}

#pragma mark - Private

- (NSString *)description {
	NSMutableString *desc = [NSMutableString new];
	[desc appendFormat:@"tag: %@", [[self class] tagName]];
	[desc appendFormat:@"\nrequired: %@", self.required ? @"YES" : @"NO"];
	if (self.name) {
		[desc appendFormat:@"\nname: %@", self.name];
	}
	if (self.value) {
		[desc appendFormat:@"\nvalue: %@", self.attributes[@"value"]];
		[desc appendFormat:@"\ncalculated value: %@", self.value];
	}
	if (self.function) {
		[desc appendFormat:@"\nfunction: %@", self.function];
	}
	if (self.url) {
		[desc appendFormat:@"\nurl: %@", self.url];
	}
	return desc;
}

- (void)tt_setup {
	_subtags = [NSMutableArray new];
}

@end
