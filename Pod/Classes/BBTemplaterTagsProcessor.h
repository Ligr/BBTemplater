//
//  BBTemplaterTagsProcessor.h
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 7/27/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBTemplaterTag.h"

@interface BBTemplaterTagsProcessor : NSObject

- (id)initWithTag:(BBTemplaterTag *)tag data:(id)data;
- (id)initWithTags:(NSArray *)tags data:(id)data;
- (void)process:(void(^)(NSError *error))callback;

@end
