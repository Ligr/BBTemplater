//
//  BBtemplaterPhoneValueAnalyzer.m
//  BalanceBy
//
//  Created by Alex on 8/6/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBtemplaterPhoneValueAnalyzer.h"

@interface BBTemplaterPhoneValueAnalyzer () {
	NSInteger _countryCodeLength;
	NSInteger _providerCodeLength;
}

@end

@implementation BBTemplaterPhoneValueAnalyzer

- (NSString *)valueForKey:(NSString *)key inContext:(BBTemplaterContext *)context {
	BOOL searchCountry = [key isEqualToString:_countryCodeKey];
	BOOL searchCode = [key isEqualToString:_providerCodeKey];
	BOOL searchNumber = [key isEqualToString:_numberKey];
	NSString *result = nil;
	if (searchCountry || searchCode || searchNumber) {
		NSString *fullPhone = [context storedValueForKey:@"account.login"];
		fullPhone = [self stringByRemovingNonNumericSymbolsFromString:fullPhone];
		if (fullPhone && fullPhone.length > (_countryCodeLength + _providerCodeLength)) {
			if (searchCountry) {
				result = [fullPhone substringToIndex:_countryCodeLength];
			} else if (searchCode) {
				result = [fullPhone substringWithRange:NSMakeRange(_countryCodeLength, _providerCodeLength)];
			} else {
				result = [fullPhone substringFromIndex:_countryCodeLength + _providerCodeLength];
			}
		}
	}
	return result;
}

#pragma mark - Private

- (NSString *)stringByRemovingNonNumericSymbolsFromString:(NSString *)string {
	NSScanner *scanner = [NSScanner scannerWithString:string];
	NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	NSMutableString *resultString = [NSMutableString new];
	
	while ([scanner isAtEnd] == NO) {
		NSString *buffer;
		if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
			[resultString appendString:buffer];
		} else {
			[scanner setScanLocation:([scanner scanLocation] + 1)];
		}
	}
	return resultString;
}

- (id)init {
	return [self initWithCountryCodeLength:3 providerCodeLegth:2];
}

- (id)initWithCountryCodeLength:(NSInteger)countryCodeLength providerCodeLegth:(NSInteger)providerCodeLegth {
	self = [super init];
	if (self) {
		_countryCodeKey = @"phone.country";
		_providerCodeKey = @"phone.code";
		_numberKey = @"phone.number";
		_countryCodeLength = countryCodeLength;
		_providerCodeLength = providerCodeLegth;
	}
	return self;
}

@end
