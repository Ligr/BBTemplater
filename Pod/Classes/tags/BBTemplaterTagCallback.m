//
//  BBTeamplaterTagCallback.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 7/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagCallback.h"

#import "BBTemplaterTagsProcessor.h"

@implementation BBTemplaterTagCallback

+ (NSString *)tagName {
	return @"callback";
}

- (id)initWithAttributes:(NSDictionary *)attributes context:(BBTemplaterContext *)context {
	self = [super initWithAttributes:attributes context:context];
	if (self) {
		NSString *name = self.name;
		if (name) {
			[context registerCallback:self forName:name];
		} else {
			NSLog(@"[BBTemplaterTagCallback][ERROR]: missing attribute 'name'");
		}
	}
	return self;
}

- (BOOL)needProcessing {
	return NO;
}

- (void)process:(void (^)(id, NSError *))callback {
	id data = [self.context data];
	BBTemplaterTagsProcessor *processor = [[BBTemplaterTagsProcessor alloc] initWithTags:self.subtags data:data];
	[processor process:^(NSError *error) {
		callback(data, error);
	}];
}

@end
