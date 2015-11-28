//
//  BBTemplaterTagsProvider.h
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBTemplaterTag.h"
#import "BBTemplaterContext.h"

@interface BBTemplaterTagsProvider : NSObject

- (BBTemplaterTag *)tagWithName:(NSString *)name attributes:(NSDictionary *)attributes context:(BBTemplaterContext *)context;
- (void)registerTag:(Class)tag withName:(NSString *)name;

@end
