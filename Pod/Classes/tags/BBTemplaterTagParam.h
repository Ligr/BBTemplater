//
//  BBTemplaterTagParam.h
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterTag.h"

@interface BBTemplaterTagParam : BBTemplaterTag

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) BOOL includeHidden;

@end
