//
//  BBTemplaterTagXpath.m
//  NewsBy
//
//  Created by Alex on 10/11/15.
//  Copyright © 2015 Home. All rights reserved.
//

#import "BBTemplaterTagXpath.h"

#import <LPXML/LPXML.h>

#import "BBTemplaterErrors.h"
#import "BBTemplaterTagElse.h"

@interface BBTemplaterTagXpath () {
	BBTemplaterTagElse *_elseTag;
	BOOL _needSubtagsProcessing;
}

@end

@implementation BBTemplaterTagXpath

+ (NSString *)tagName {
	return @"xpath";
}

- (void)addSubtag:(BBTemplaterTag *)tag {
	if ([tag isKindOfClass:[BBTemplaterTagElse class]]) {
		_elseTag = (BBTemplaterTagElse *)tag;
	} else {
		[super addSubtag:tag];
	}
}

- (void)process:(void (^)(id, NSError *))callback {
	NSString *data = self.value ? : [self.context data];
	NSString *xpath = self.attributes[@"xpath"];
	NSString *result = nil;
	NSError *error = nil;
	if (data && xpath) {
		LPXML *xml = nil;
		xml = [[LPXML alloc] initWithHtmlString:data encoding:self.context.dataEncoding];
		result = [xml contentForXpath:xpath];
	} else {
		if (!data) {
			NSLog(@"[BBTemplaterTagXpath][ERROR]: data is required");
			error = [BBTemplaterErrors requiredDataIsMissing:@"data or 'value' tag are required"];
		}
		if (!xpath) {
			NSLog(@"[BBTemplaterTagXpath][ERROR]: 'xpath' is required");
			error = [BBTemplaterErrors missingAttributeError:@"'xpath' parameter is required"];
		}
	}
	BOOL success = (error == nil) && (result != nil) && ([result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0);
	_needSubtagsProcessing = success;
	if (success || !_elseTag) {
		callback(result, error);
	} else {
		[_elseTag process:^(id data, NSError *error) {
			callback(data, error);
		}];
	}
}

- (BOOL)needSubtagsProcessing {
	return _needSubtagsProcessing;
}

#pragma mark - Private

- (id)initWithAttributes:(NSDictionary *)attributes context:(BBTemplaterContext *)context {
	self = [super initWithAttributes:attributes context:context];
	if (self) {
		_needSubtagsProcessing = NO;
	}
	return self;
}

@end
