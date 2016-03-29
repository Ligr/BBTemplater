//
//  BBTemplaterTagSearch.m
//  BalanceBy
//
//  Created by Alex on 7/1/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagSearch.h"

#import "BBTemplaterStringUtils.h"
#import "BBTemplaterFunctions.h"
#import "BBTemplaterTagElse.h"
#import "BBTemplaterErrors.h"

@interface BBTemplaterTagSearch () {
	BBTemplaterTagElse *_elseTag;
	BOOL _needSubtagsProcessing;
}

@end

@implementation BBTemplaterTagSearch

+ (NSString *)tagName {
	return @"search";
}

- (void)addSubtag:(BBTemplaterTag *)tag {
	if ([tag isKindOfClass:[BBTemplaterTagElse class]]) {
		_elseTag = (BBTemplaterTagElse *)tag;
	} else {
		[super addSubtag:tag];
	}
}

- (BOOL)needSubtagsProcessing {
	return _needSubtagsProcessing;
}

- (void)process:(void(^)(id data, NSError *error))callback {
	NSString *data = [self.context data];
	NSString *tagValue = self.value;
	__block id result = tagValue ? : nil;
	NSString *initialData = tagValue ? : data;
	
	if (![initialData isKindOfClass:[NSString class]]) {
		callback(nil, [BBTemplaterErrors invalidFormatError:@"[BBTemplaterTagSearch][ERROR]: unsupported input data type"]);
		return;
	}
	
	NSString *srcString = initialData;
	NSString *start = self.start;
	NSString *end = self.end;
	NSString *offset = self.offset;
	NSError *error = nil;
	__block NSMutableArray *groupValues = nil;
	
	// reduce initial string
	if (start) {
		NSRange startRange = [srcString rangeOfString:start];
		if (startRange.location != NSNotFound) {
			NSUInteger length = srcString.length - startRange.location;
			if (end) {
				NSRange endRange = [srcString rangeOfString:end options:NSCaseInsensitiveSearch range:NSMakeRange(startRange.location, srcString.length - startRange.location)];
				if (endRange.location != NSNotFound) {
					length = (endRange.location + endRange.length) - startRange.location;
				}
			}
			srcString = [srcString substringWithRange:NSMakeRange(startRange.location, length)];
			result = srcString;
		}
	} else if (offset) {
		NSInteger offsetInt = [offset integerValue];
		srcString = [srcString substringFromIndex:offsetInt];
		result = srcString;
	}

	// calculate final value
	NSString *split = self.split;
	NSString *regexStr = self.regex;
	if (split) {
		result = [srcString componentsSeparatedByString:split];
	} else if (regexStr && srcString) {
		NSMutableString *updatesString = [srcString mutableCopy];
		NSString *replace = self.replace;
		NSInteger groupIndex = self.group;
		
		NSMutableArray *results = [NSMutableArray new];

		NSRegularExpression *regex = self.context.regexCache[regexStr];
		if (!regex) {
			regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
			self.context.regexCache[regexStr] = regex;
		}
		
		[regex enumerateMatchesInString:srcString options:0 range:NSMakeRange(0, [srcString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
			// store all group values
			groupValues = [NSMutableArray new];
			for (NSInteger i = 0; i < match.numberOfRanges; i++) {
				NSRange range = [match rangeAtIndex:i];
				NSString *matchStr = [srcString substringWithRange:range];
				[groupValues addObject:matchStr];
			}
			
			// update / store result
			NSRange range = [match rangeAtIndex:groupIndex];
			NSString *matchStr = [srcString substringWithRange:range];
			[results addObject:matchStr];
			if (replace) {
				[updatesString replaceOccurrencesOfString:matchStr withString:replace options:0 range:NSMakeRange(0, updatesString.length)];
			}
		}];
		
		if (replace) {
			result = updatesString;
		} else {
			if (results.count > 1) {
				result = results;
			} else {
				result = results.count == 1 ? results[0] : nil;
			}
		}
	}
	
	// apply function
	NSString *function = super.function;
	if (function && !error) {
		result = [BBTemplaterFunctions calculateValue:result withFunctionDetails:function error:&error];
	}
	
	// set variable
	NSString *var = self.attributes[@"var"];
	if (var) {
		[self.context storeValue:result forVariable:var];
	}
	
	BOOL searchSuccess = (result != nil && error == nil);
	_needSubtagsProcessing = searchSuccess;
	if (searchSuccess || !_elseTag) {
		[self.context pushSearchGroup:groupValues];
		callback(result, error);
	} else {
		[_elseTag willStartWithData:initialData];
		[_elseTag process:^(id data, NSError *error) {
			callback(data, error);
		}];
	}
}

- (NSString *)regex {
	return self.attributes[@"regex"];
}

- (NSString *)replace {
	return self.attributes[@"replace"];
}

- (NSString *)split {
	return self.attributes[@"split"];
}

- (NSString *)start {
	return self.attributes[@"start"];
}

- (NSString *)end {
	return self.attributes[@"end"];
}

- (NSString *)offset {
	return self.attributes[@"offset"];
}

- (NSInteger)group {
	NSString *group = self.attributes[@"group"];
	NSInteger groupIndex = group ? [group integerValue] : 0;
	return groupIndex;
}

- (void)didEnd {
	[super didEnd];
	if (_needSubtagsProcessing || !_elseTag) {
		[self.context popSearchGroup];
	}
}

#pragma mark - Private

- (id)initWithAttributes:(NSDictionary *)attributes context:(BBTemplaterContext *)context {
	self = [super initWithAttributes:attributes context:context];
	if (self) {
		_needSubtagsProcessing = NO;
	}
	return self;
}

- (NSString *)description {
	NSMutableString *desc = [[super description] mutableCopy];
	if (self.regex) {
		[desc appendFormat:@"\nregex: %@", self.regex];
	}
	if (self.replace) {
		[desc appendFormat:@"\nreplace: %@", self.replace];
	}
	if (self.split) {
		[desc appendFormat:@"\nsplit: %@", self.split];
	}
	if (self.start) {
		[desc appendFormat:@"\nstart: %@", self.start];
	}
	if (self.end) {
		[desc appendFormat:@"\nend: %@", self.end];
	}
	if (self.offset) {
		[desc appendFormat:@"\noffset: %@", self.offset];
	}
	if (self.group) {
		[desc appendFormat:@"\ngroup: %@", @(self.group)];
	}
	return desc;
}

@end
