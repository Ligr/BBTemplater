//
//  BBTemplaterTagSearch.h
//  BalanceBy
//
//  Created by Alex on 7/1/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTag.h"

@interface BBTemplaterTagSearch : BBTemplaterTag

@property (nonatomic, readonly) NSString *regex;
@property (nonatomic, readonly) NSString *replace;
@property (nonatomic, readonly) NSString *split;
@property (nonatomic, readonly) NSString *start;
@property (nonatomic, readonly) NSString *end;
@property (nonatomic, readonly) NSString *offset;
@property (nonatomic, readonly) NSInteger group;

@end
