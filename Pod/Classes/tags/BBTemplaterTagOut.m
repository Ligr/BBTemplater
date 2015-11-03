//
//  BBTemplaterTagOut.m
//  BalanceBy
//
//  Created by Alex on 7/21/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagOut.h"

#import "BBTemplaterErrors.h"
#import "BBTemplaterTagParam.h"

@interface BBTemplaterTagOut () {
	NSMutableArray *_params;
}

@end

@implementation BBTemplaterTagOut

+ (NSString *)tagName {
	return @"out";
}

#pragma mark - Private

- (void)addSubtag:(BBTemplaterTag *)tag {
	if ([tag isKindOfClass:[BBTemplaterTagParam class]]) {
		[_params addObject:tag];
	} else {
		[super addSubtag:tag];
	}
}

- (void)process:(void (^)(id, NSError *))callback {
	NSString *data = [self.context data];
	NSString *stringValue = self.value ? : data;
	NSDictionary *dictValue = [self paramsToDictionary];
	NSString *name = self.name;
	NSError *error = nil;
	if ((stringValue || dictValue) && name) {
		[self.context outValue:((dictValue && dictValue.count > 0) ? dictValue : stringValue) withName:name];
	} else {
		error = [BBTemplaterErrors invalidFormatError:@"value and name are required"];
	}
	callback(data, error);
}

- (NSDictionary *)paramsToDictionary {
	NSMutableDictionary *params = [NSMutableDictionary new];
	for (BBTemplaterTagParam *tag in _params) {
		params[tag.name] = tag.value;
	}
	return params;
}

- (id)initWithAttributes:(NSDictionary *)attributes context:(BBTemplaterContext *)context {
	self = [super initWithAttributes:attributes context:context];
	if (self) {
		_params = [NSMutableArray new];
	}
	return self;
}

@end
