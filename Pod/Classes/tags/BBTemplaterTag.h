//
//  BBTemplaterTag.h
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBTemplaterContext.h"

@interface BBTemplaterTag : NSObject

@property (nonatomic, readonly) NSArray *subtags;
@property (nonatomic, readonly) BBTemplaterContext *context;
@property (nonatomic, readonly) NSDictionary *attributes;
@property (nonatomic, readonly) BOOL required;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *value;
@property (nonatomic, readonly) NSString *function;
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSString *onSuccessMessage;
@property (nonatomic, readonly) BBTemplaterTag *onSuccessCallback;
@property (nonatomic, readonly) NSString *onErrorMessage;
@property (nonatomic, readonly) BBTemplaterTag *onErrorCallback;

@property (nonatomic, readonly) BOOL needProcessing;
@property (nonatomic, readonly) BOOL needSubtagsProcessing;

+ (NSString *)tagName;

- (instancetype)initWithAttributes:(NSDictionary *)attributes context:(BBTemplaterContext *)context;
- (void)addSubtag:(BBTemplaterTag *)tag;
- (void)process:(void(^)(id data, NSError *error))callback;
- (void)willStartWithData:(id)data;
- (void)didEnd;

@end
