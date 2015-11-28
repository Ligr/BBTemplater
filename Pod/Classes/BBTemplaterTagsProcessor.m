//
//  BBTemplaterTagsProcessor.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 7/27/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagsProcessor.h"

#import "Sequencer.h"
#import "BBTemplaterErrors.h"

@interface BBTemplaterTagsProcessor () {
	NSArray *_tags;
	id _initialData;
}

@end

@implementation BBTemplaterTagsProcessor

- (id)initWithTag:(BBTemplaterTag *)tag data:(id)data {
	self = [super init];
	if (self) {
		_tags = @[tag];
		_initialData = data;
	}
	return self;
}

- (id)initWithTags:(NSArray *)tags data:(id)data {
	self = [super init];
	if (self) {
		_tags = tags;
		_initialData = data;
	}
	return self;
}

- (void)process:(void(^)(NSError *error))callback {
	Sequencer *sequencer = [[Sequencer alloc] init];
	for (BBTemplaterTag *tag in _tags) {
		[sequencer enqueueStep:^(id result, SequencerCompletion completion) {
			if (result) {
				completion(result);
			} else {
				[self processTag:tag withData:_initialData callback:^(NSError *error) {
					dispatch_async(dispatch_get_main_queue(), ^{
						completion(error);
					});
				}];
			}
		}];
	}
	[sequencer enqueueStep:^(id result, SequencerCompletion completion) {
		callback(result);
	}];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		[sequencer run];
	});
}

#pragma mark - Private

- (void)processTag:(BBTemplaterTag *)tag withData:(id)srcData callback:(void(^)(NSError *error))callback {
	if (tag.needProcessing) {
		[tag willStartWithData:srcData];
		[tag process:^(id data, NSError *error) {
#if DEBUG
			if (error) {
				NSLog(@"\n====================\ninput data:\n%@\n==========\n%@\n==========\nresults:\n%@\nerror: %@\n====================", srcData, tag, data, error);
			}
#endif
			if (error || (tag.required && data == nil)) {
				if (!error) {
					error = [BBTemplaterErrors requiredDataIsMissing:[NSString stringWithFormat:@"Required tag '%@' returned empty data", NSStringFromClass([tag class])]];
				}
				[tag didEnd];
				callback(error);
			} else if (tag.needSubtagsProcessing) {
				Sequencer *sequencer = [[Sequencer alloc] init];
				for (BBTemplaterTag *subTag in tag.subtags) {
					[sequencer enqueueStep:^(id result, SequencerCompletion completion) {
						if (result) {
							completion(result);
						} else {
							[self processTag:subTag withData:data callback:^(NSError *error) {
								completion(error);
							}];
						}
					}];
				}
				[sequencer enqueueStep:^(id result, SequencerCompletion completion) {
					[tag didEnd];
					callback(result);
				}];
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
					[sequencer run];					
				});
			} else {
				[tag didEnd];
				callback(nil);
			}
		}];
	} else {
		callback(nil);
	}
}

@end
