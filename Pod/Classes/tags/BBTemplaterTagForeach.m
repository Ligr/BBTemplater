//
//  BBTemplaterTagForeach.m
//  BalanceBy
//
//  Created by Alex on 7/5/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagForeach.h"

#import "Sequencer.h"
#import "BBTemplaterTagsProcessor.h"

@interface BBTemplaterTagForeach () {

}

@end

@implementation BBTemplaterTagForeach

+ (NSString *)tagName {
	return @"foreach";
}

- (BOOL)needSubtagsProcessing {
	return NO;
}

#pragma mark - Private

- (void)process:(void (^)(id data, NSError *error))callback {
	id data = [self.context data];
	NSArray *dataArr = nil;
	if ([data isKindOfClass:[NSArray class]]) {
		dataArr = (NSArray *)data;
	} else if (data) {
		dataArr = @[data];
	} else {
		callback(nil, nil);
	}
	if (dataArr) {
		Sequencer *sequencer = [[Sequencer alloc] init];
		for (id oneData in dataArr) {
			[sequencer enqueueStep:^(id result, SequencerCompletion completion) {
				if (result) {
					completion(result);
				} else {
					[self processSubtagsWithData:oneData callback:^(id data, NSError *error) {
						completion(error);
					}];
				}
			}];
		}
		[sequencer enqueueStep:^(id result, SequencerCompletion completion) {
			callback(data, result);
		}];
		[sequencer run];
	}
}

#pragma mark - Private

- (void)processSubtagsWithData:(id)data callback:(void (^)(id data, NSError *error))callback {
	BBTemplaterTagsProcessor *processor = [[BBTemplaterTagsProcessor alloc] initWithTags:self.subtags data:data];
	[processor process:^(NSError *error) {
		callback(data, error);
	}];
}

@end
