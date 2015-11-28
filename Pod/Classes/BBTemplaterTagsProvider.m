//
//  BBTemplaterTagsProvider.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTagsProvider.h"

#import "BBTemplaterTagProvider.h"
#import "BBTemplaterTagParam.h"
#import "BBTemplaterTagHeader.h"
#import "BBTemplaterTagVar.h"
#import "BBTemplaterTagForeach.h"
#import "BBTemplaterTagSearch.h"
#import "BBTemplaterTagSubaccount.h"
#import "BBTemplaterTagOut.h"
#import "BBTemplaterTagCallback.h"
#import "BBTemplaterTagExecute.h"
#import "BBTemplaterTagElse.h"
#import "BBTemplaterTagPreference.h"
#import "BBTemplaterTagDialog.h"
#import "BBTemplaterTagToast.h"
#import "BBTemplaterTagException.h"
#import "BBTemplaterTagXml.h"
#import "BBTemplaterTagXpath.h"

@interface BBTemplaterTagsProvider () {
	NSMutableDictionary *_tagToClassBinding;
}

@end

@implementation BBTemplaterTagsProvider

- (BBTemplaterTag *)tagWithName:(NSString *)name attributes:(NSDictionary *)attributes context:(BBTemplaterContext *)context {
	BBTemplaterTag *tag = nil;
	Class tagClass = _tagToClassBinding[name];
	if (tagClass) {
		tag = [[tagClass alloc] initWithAttributes:attributes context:context];
	} else {
		NSLog(@"[BBTemplaterTagsProvider][ERROR]: unsupported tag '%@'", name);
	}
	return tag;
}

- (void)registerTag:(Class)tag withName:(NSString *)name {
	_tagToClassBinding[name] = tag;
}

#pragma mark - Private

- (id)init {
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup {
	_tagToClassBinding = [@{
						  @"root": [BBTemplaterTag class],
						  [BBTemplaterTagProvider tagName]: [BBTemplaterTagProvider class],
						  [BBTemplaterTagParam tagName]: [BBTemplaterTagParam class],
						  [BBTemplaterTagHeader tagName]: [BBTemplaterTagHeader class],
						  [BBTemplaterTagVar tagName]: [BBTemplaterTagVar class],
						  [BBTemplaterTagForeach tagName]: [BBTemplaterTagForeach class],
						  [BBTemplaterTagSearch tagName]: [BBTemplaterTagSearch class],
						  [BBTemplaterTagSubaccount tagName]: [BBTemplaterTagSubaccount class],
						  [BBTemplaterTagOut tagName]: [BBTemplaterTagOut class],
						  [BBTemplaterTagCallback tagName]: [BBTemplaterTagCallback class],
						  [BBTemplaterTagElse tagName]: [BBTemplaterTagElse class],
						  [BBTemplaterTagPreference tagName]: [BBTemplaterTagPreference class],
						  [BBTemplaterTagExecute tagName]: [BBTemplaterTagExecute class],
						  [BBTemplaterTagDialog tagName]: [BBTemplaterTagDialog class],
						  [BBTemplaterTagToast tagName]: [BBTemplaterTagToast class],
						  [BBTemplaterTagException tagName]: [BBTemplaterTagException class],
						  [BBTemplaterTagXml tagName]: [BBTemplaterTagXml class],
						  [BBTemplaterTagXpath tagName]: [BBTemplaterTagXpath class]
						  } mutableCopy];
}

@end
