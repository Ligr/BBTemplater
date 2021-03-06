//
//  BBTemplater.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplater.h"

#import "BBTemplaterTag.h"
#import "BBTemplaterTagsProvider.h"
#import "BBTemplaterTagsProcessor.h"
#import "BBTEmplaterValueProcessor.h"

@interface BBTemplater () <NSXMLParserDelegate> {
	NSString *_data;
	NSString *_template;
	NSXMLParser *_parser;
	BBTemplaterTag *_rootTag;
	BBTemplaterTagsProvider *_tagsProvider;
	BBTemplaterContext *_context;
	NSMutableArray *_tagsStack;
	NSArray *_additionalValueAnalyzers;
	void(^_templaterCallback)(NSError *error);
}

@end

@implementation BBTemplater

- (id)initWithTemplate:(NSString *)templateStr data:(NSString *)data {
	return [self initWithTemplate:templateStr data:data valueAnalyzers:nil];
}

- (id)initWithTemplate:(NSString *)templateStr data:(NSString *)data valueAnalyzers:(NSArray *)valueAnalyzers {
	self = [super init];
	if (self) {
		_template = templateStr;
		_data = data;
		_additionalValueAnalyzers = valueAnalyzers;
		[self setup];
	}
	return self;
}

- (void)process:(void(^)(NSError *error))callback {
	if ([_template stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
		_templaterCallback = callback;
		_parser = [[NSXMLParser alloc] initWithData:[_template dataUsingEncoding:NSUTF8StringEncoding]];
		_parser.delegate = self;
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			[_parser parse];
		});
	} else {
		callback(nil);
	}
}

- (void)registerVariables:(NSDictionary *)variables {
	[_context storeValues:variables];
}

- (void)setDataEncoding:(NSStringEncoding)encoding {
	_context.dataEncoding = encoding;
}

- (id)variableForKey:(NSString *)key; {
	return [_context storedValueForKey:key];
}

- (NSArray *)outValuesWithName:(NSString *)name {
	return [_context outValuesWithName:name];
}

- (void)registerTag:(Class)tag withName:(NSString *)name {
	[_tagsProvider registerTag:tag withName:name];
}

#pragma mark - Private

- (void)setup {
	BBTemplaterValueProcessor *valueProcessor = [[BBTemplaterValueProcessor alloc] init];
	for (id<BBTemplaterValueAnalyzer> analyzer in _additionalValueAnalyzers) {
		[valueProcessor registerValueAnalyzer:analyzer];
	}
	_context = [[BBTemplaterContext alloc] initWithValueProcessor:valueProcessor];
	_context.dataEncoding = NSUTF8StringEncoding;
	_tagsProvider = [BBTemplaterTagsProvider new];
	_tagsStack = [NSMutableArray new];
}

- (void)parsingDidFinishWithError:(NSError *)error {
	if (error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (_templaterCallback) {
				_templaterCallback(error);
				_templaterCallback = nil;
			}
		});
	} else {
		[self processTag:_rootTag withData:_data callback:^(NSError *error) {
			if (_templaterCallback) {
				_templaterCallback(error);
				_templaterCallback = nil;
			}
		}];
	}
}

- (void)tagStarted:(BBTemplaterTag *)tag {
	BBTemplaterTag *topTag = [_tagsStack lastObject];
	[_tagsStack addObject:tag];
	if (topTag) {
		[topTag addSubtag:tag];
	} else {
		_rootTag = tag;
	}
}

- (void)tagEnded {
	[_tagsStack removeLastObject];
}

- (void)processTag:(BBTemplaterTag *)tag withData:(id)data callback:(void(^)(NSError *error))callback {
	BBTemplaterTagsProcessor *processor = [[BBTemplaterTagsProcessor alloc] initWithTag:_rootTag data:data];
	[processor process:^(NSError *error) {
		callback(error);
	}];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	BBTemplaterTag *tag = [_tagsProvider tagWithName:elementName attributes:attributeDict context:_context];
	if (tag) {
		[self tagStarted:tag];
	} else {
		[parser abortParsing];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	[self tagEnded];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	[self parsingDidFinishWithError:parseError];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
	[self parsingDidFinishWithError:validationError];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {

}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[self parsingDidFinishWithError:nil];
}

@end
