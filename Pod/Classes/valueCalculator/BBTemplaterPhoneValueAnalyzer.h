//
//  BBtemplaterPhoneValueAnalyzer.h
//  BalanceBy
//
//  Created by Alex on 8/6/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBTemplaterValueAnalyzer.h"

@interface BBTemplaterPhoneValueAnalyzer : NSObject <BBTemplaterValueAnalyzer>

@property (nonatomic, strong) NSString *countryCodeKey;
@property (nonatomic, strong) NSString *providerCodeKey;
@property (nonatomic, strong) NSString *numberKey;

- (id)initWithCountryCodeLength:(NSInteger)countryCodeLength providerCodeLegth:(NSInteger)providerCodeLegth;

@end
