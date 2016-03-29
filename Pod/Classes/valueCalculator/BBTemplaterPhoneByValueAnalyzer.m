//
//  BBTemplaterPhoneByValueAnalyzer.m
//  BalanceBy
//
//  Created by Alex on 8/6/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterPhoneByValueAnalyzer.h"

@implementation BBTemplaterPhoneByValueAnalyzer

- (id)init {
	self = [super initWithCountryCodeLength:3 providerCodeLegth:2];
	if (self) {
		self.countryCodeKey = @"phone.countryBY";
		self.providerCodeKey = @"phone.codeBY";
		self.numberKey = @"phone.numberBY";
	}
	return self;
}

@end
