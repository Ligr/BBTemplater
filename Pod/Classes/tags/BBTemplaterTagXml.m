//
//  BBTemplaterTagXml.m
//  NewsBy
//
//  Created by Alex on 10/11/15.
//  Copyright © 2015 Home. All rights reserved.
//

#import "BBTemplaterTagXml.h"

@implementation BBTemplaterTagXml

+ (NSString *)tagName {
	return @"xml";
}

- (void)process:(void (^)(id, NSError *))callback {
	NSString *data = self.value ? : [self.context data];
	if (data) {
		data = [NSString stringWithFormat:@"<xml>%@</xml>", data];
	}
	callback(data, nil);
}

@end
