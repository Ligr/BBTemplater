//
//  BBTemplaterErrors.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterErrors.h"

@implementation BBTemplaterErrors

+ (NSError *)missingAttributeError:(NSString *)attributeName {
	return [NSError errorWithDomain:BB_ERROR_DOMAIN code:BB_EC_MISSING_ATTRIBUTE userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"missing '%@' attribute", attributeName]}];
}

+ (NSError *)unsupporterRequestTypeError:(NSString *)requestType {
	return [NSError errorWithDomain:BB_ERROR_DOMAIN code:BB_EC_UNSUPPORTED_REQUEST_TYPE userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"unsupported request type '%@'", requestType]}];
}

+ (NSError *)invalidFormatError:(NSString *)message {
	return [NSError errorWithDomain:BB_ERROR_DOMAIN code:BB_EC_INVALID_FORMAT userInfo:@{NSLocalizedDescriptionKey: message}];
}

+ (NSError *)invalidParameterError:(NSString *)message {
	return [NSError errorWithDomain:BB_ERROR_DOMAIN code:BB_EC_INVALID_PARAMETER userInfo:@{NSLocalizedDescriptionKey: message}];
}

+ (NSError *)genericError:(NSString *)message {
	return [NSError errorWithDomain:BB_ERROR_DOMAIN code:BB_EC_GENERIC userInfo:@{NSLocalizedDescriptionKey: message}];
}

+ (NSError *)requiredDataIsMissing:(NSString *)message {
	return [NSError errorWithDomain:BB_ERROR_DOMAIN code:BB_EC_REQUIRED_DATA_MISSING userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
