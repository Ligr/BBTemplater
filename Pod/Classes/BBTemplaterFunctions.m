//
//  BBTemplaterFunctions.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/30/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterFunctions.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "BBTemplaterErrors.h"

typedef NS_ENUM(NSInteger, BBTemplaterFunctionType) {
	BBTemplaterFunctionTypeUnknown,
	BBTemplaterFunctionTypeAdd,
	BBTemplaterFunctionTypeSub,
	BBTemplaterFunctionTypeMul,
	BBTemplaterFunctionTypeDiv,
	BBTemplaterFunctionTypeMin,
	BBTemplaterFunctionTypeMax,
	BBTemplaterFunctionTypeIndex,
	BBTemplaterFunctionTypeHmacSHA1,
	BBTemplaterFunctionTypeEncrypt,
	BBTemplaterFunctionTypePKCS5
};

typedef NS_ENUM(NSInteger, BBTemplaterFunctionsEncoding) {
	BBTemplaterFunctionsEncodingBase64,
	BBTemplaterFunctionsEncodingHex
};

typedef NS_ENUM(NSInteger, BBTemplaterFunctionsEncryption) {
	BBTemplaterFunctionsEncryptionUnknown,
	BBTemplaterFunctionsEncryptionMD5,
	BBTemplaterFunctionsEncryptionSHA1,
	BBTemplaterFunctionsEncryptionSHA256,
	BBTemplaterFunctionsEncryptionSHA512
};

@implementation BBTemplaterFunctions

+ (NSString *)calculateValue:(id)value withFunctionDetails:(NSString *)functionDetails error:(NSError **)error {
	NSString *result = nil;
	NSArray *params = [functionDetails componentsSeparatedByString:@","];
	if (params.count > 1) {
		NSString *functionName = [params[0] lowercaseString];
		BBTemplaterFunctionType functionType = [self functionTypeForName:functionName];
		if ((functionType == BBTemplaterFunctionTypeIndex && [value isKindOfClass:[NSArray class]]) || (functionType != BBTemplaterFunctionTypeIndex && [value isKindOfClass:[NSString class]])) {
			NSArray *functionParams = [params subarrayWithRange:NSMakeRange(1, params.count - 1)];
			switch (functionType) {
				case BBTemplaterFunctionTypeAdd:
				case BBTemplaterFunctionTypeSub:
				case BBTemplaterFunctionTypeMul:
				case BBTemplaterFunctionTypeDiv:
					result = [self applyArithmeticFunction:functionType toValue:value otherValues:functionParams error:error];
					break;
				case BBTemplaterFunctionTypeMin:
					result = [self minFromValues:[functionParams arrayByAddingObject:value]];
					break;
				case BBTemplaterFunctionTypeMax:
					result = [self maxFromValues:[functionParams arrayByAddingObject:value]];
					break;
				case BBTemplaterFunctionTypeIndex:
					result = [self applyIndexFunctionWithIndex:functionParams[0] values:value error:error];
					break;
				case BBTemplaterFunctionTypeHmacSHA1:
					result = [self applyHmacSHA1FunctionWithValue:value options:functionParams error:error];
					break;
				case BBTemplaterFunctionTypeEncrypt:
					result = [self applyEncryptFunctionWithValue:value options:functionParams error:error];
					break;
				case BBTemplaterFunctionTypePKCS5:
					result = [self applyPKCS5FunctionWithValue:value options:functionParams error:error];
					break;
				case BBTemplaterFunctionTypeUnknown:
					*error = [BBTemplaterErrors invalidParameterError:[NSString stringWithFormat:@"unsupported function '%@'", functionName]];
					break;
			}
		} else {
			*error = [BBTemplaterErrors invalidFormatError:@"function value has incorrect type"];
		}
	} else {
		*error = [BBTemplaterErrors invalidFormatError:@"function should have at least two params"];
	}
	return result;
}

#pragma mark - Private

+ (BBTemplaterFunctionType)functionTypeForName:(NSString *)functionName {
	BBTemplaterFunctionType type = BBTemplaterFunctionTypeUnknown;
	if ([functionName isEqualToString:@"add"]) {
		type = BBTemplaterFunctionTypeAdd;
	} else if ([functionName isEqualToString:@"sub"]) {
		type = BBTemplaterFunctionTypeSub;
	} else if ([functionName isEqualToString:@"mul"]) {
		type = BBTemplaterFunctionTypeMul;
	} else if ([functionName isEqualToString:@"div"]) {
		type = BBTemplaterFunctionTypeDiv;
	} else if ([functionName isEqualToString:@"min"]) {
		type = BBTemplaterFunctionTypeMin;
	} else if ([functionName isEqualToString:@"max"]) {
		type = BBTemplaterFunctionTypeMax;
	} else if ([functionName isEqualToString:@"index"]) {
		type = BBTemplaterFunctionTypeIndex;
	} else if ([functionName isEqualToString:@"hmacsha1"]) {
		type = BBTemplaterFunctionTypeHmacSHA1;
	} else if ([functionName isEqualToString:@"encrypt"]) {
		type = BBTemplaterFunctionTypeEncrypt;
	} else if ([functionName isEqualToString:@"pkcs5"]) {
		type = BBTemplaterFunctionTypePKCS5;
	}
	return type;
}

+ (BBTemplaterFunctionsEncoding)encodingForName:(NSString *)encodingName {
	BBTemplaterFunctionsEncoding encoding = BBTemplaterFunctionsEncodingBase64;
	if ([[encodingName lowercaseString] isEqualToString:@"hex"]) {
		encoding = BBTemplaterFunctionsEncodingHex;
	}
	return encoding;
}

+ (BBTemplaterFunctionsEncryption)encryptionForName:(NSString *)encryptionName {
	BBTemplaterFunctionsEncryption encryption = BBTemplaterFunctionsEncryptionUnknown;
	encryptionName = [encryptionName lowercaseString];
	if ([encryptionName isEqualToString:@"md5"]) {
		encryption = BBTemplaterFunctionsEncryptionMD5;
	} else if ([encryptionName isEqualToString:@"sha-1"]) {
		encryption = BBTemplaterFunctionsEncryptionSHA1;
	} else if ([encryptionName isEqualToString:@"sha-256"]) {
		encryption = BBTemplaterFunctionsEncryptionSHA256;
	} else if ([encryptionName isEqualToString:@"sha-512"]) {
		encryption = BBTemplaterFunctionsEncryptionSHA512;
	}
	return encryption;
}

+ (NSString *)data:(NSData *)data toStringWithEncoding:(BBTemplaterFunctionsEncoding)encoding {
	NSString *result = nil;
	switch (encoding) {
		case BBTemplaterFunctionsEncodingBase64:
			result = [data base64EncodedStringWithOptions:0];
			break;
		case BBTemplaterFunctionsEncodingHex: {
			const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
			if (dataBuffer) {
				NSUInteger dataLength = [data length];
				NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
				for (int i = 0; i < dataLength; ++i) {
					[hexString appendString:[NSString stringWithFormat:@"%02x", dataBuffer[i]]];
				}
				result = [NSString stringWithString:hexString];
			}
		}
			break;
	}
	return result;
}

+ (NSString *)applyPKCS5FunctionWithValue:(NSString *)value options:(NSArray *)options error:(NSError **)error {
	NSString *result = nil;
	if (options.count == 3) {
		NSString *param = options[0];
		NSData *paramData = [[NSData alloc] initWithBase64EncodedString:param options:0];
		
		NSString *key = options[1];
		NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:0];
		
		NSString *encodingName = options[2];
		BBTemplaterFunctionsEncoding encoding = [self encodingForName:encodingName];
		
		NSData *data = [[NSData alloc] initWithBase64EncodedString:value options:0];

		NSUInteger dataLength = [data length];
		size_t bufferSize = dataLength + kCCBlockSizeAES128;
		void *buffer = malloc(bufferSize);
		
		size_t numBytesEncrypted = 0;
		CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
											  kCCAlgorithmAES128,
											  kCCOptionPKCS7Padding/* | kCCOptionECBMode*/,
											  keyData.bytes,
											  keyData.length,
											  paramData.bytes,
											  data.bytes,
											  data.length,
											  buffer,
											  bufferSize,
											  &numBytesEncrypted);

		if (cryptStatus == kCCSuccess) {
			NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
			result = [self data:data toStringWithEncoding:encoding];
		} else {
			free(buffer);
			*error = [BBTemplaterErrors genericError:@"PKCS5 encryption failed"];
		}
	} else {
		*error = [BBTemplaterErrors invalidFormatError:@"PKCS5 needs parameter, key and encoding type"];
	}
	return result;
}

+ (NSString *)applyEncryptFunctionWithValue:(NSString *)value options:(NSArray *)options error:(NSError **)error {
	NSString *result = nil;
	if (options.count == 2) {
		NSString *encryptionName = options[0];
		NSString *encodingName = options[1];
		BBTemplaterFunctionsEncryption encryption = [self encryptionForName:encryptionName];
		NSData *data = nil;
		switch (encryption) {
			case BBTemplaterFunctionsEncryptionMD5: {
				const char *str = value.UTF8String;
				uint8_t buffer[CC_MD5_DIGEST_LENGTH];
				CC_MD5(str, (CC_LONG)strlen(str), buffer);
				data = [[NSData alloc] initWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
			}
				break;
			case BBTemplaterFunctionsEncryptionSHA1: {
				const char *str = value.UTF8String;
				uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
				CC_SHA1(str, (CC_LONG)strlen(str), buffer);
				data = [[NSData alloc] initWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
			}
				break;
			case BBTemplaterFunctionsEncryptionSHA256: {
				const char *str = value.UTF8String;
				uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
				CC_SHA256(str, (CC_LONG)strlen(str), buffer);
				data = [[NSData alloc] initWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
			}
				break;
			case BBTemplaterFunctionsEncryptionSHA512: {
				const char *str = value.UTF8String;
				uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
				CC_SHA512(str, (CC_LONG)strlen(str), buffer);
				data = [[NSData alloc] initWithBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
			}
				break;
			case BBTemplaterFunctionsEncryptionUnknown:
				*error = [BBTemplaterErrors invalidParameterError:[NSString stringWithFormat:@"unsupported encryption '%@'", encryptionName]];
				break;
		}
		
		BBTemplaterFunctionsEncoding encoding = [self encodingForName:encodingName];
		result = [self data:data toStringWithEncoding:encoding];
	} else {
		*error = [BBTemplaterErrors invalidFormatError:@"encrypt needs key and encoding type"];
	}
	return result;
}

+ (NSString *)applyHmacSHA1FunctionWithValue:(NSString *)value options:(NSArray *)options error:(NSError **)error {
	NSString *result = nil;
	if (options.count == 2) {
		NSString *key = options[0];
		NSString *encodingName = options[1];
		
		const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
		const char *cData = [value cStringUsingEncoding:NSASCIIStringEncoding];
		
		unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
		
		CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
		NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
		
		BBTemplaterFunctionsEncoding encoding = [self encodingForName:encodingName];
		result = [self data:HMAC toStringWithEncoding:encoding];
	} else {
		*error = [BBTemplaterErrors invalidFormatError:@"HmacSHA1 needs key and encoding type"];
	}
	return result;
}

+ (NSString *)applyIndexFunctionWithIndex:(NSString *)indexStr values:(NSArray *)values error:(NSError **)error {
	NSString *result = nil;
	NSInteger index = [indexStr integerValue];
	if (index >= 0 && index < values.count) {
		result = values[index];
	} else {
		*error = [BBTemplaterErrors invalidParameterError:[NSString stringWithFormat:@"index '%@' out of bounds [0, %@]", indexStr, @(values.count)]];
	}
	return result;
}

+ (NSString *)minFromValues:(NSArray *)values {
	double value = [values[0] doubleValue];
	for (NSString *oneValue in values) {
		value = MIN(value, [oneValue doubleValue]);
	}
	return [NSString stringWithFormat:@"%@", @(value)];
}

+ (NSString *)maxFromValues:(NSArray *)values {
	double value = [values[0] doubleValue];
	for (NSString *oneValue in values) {
		value = MAX(value, [oneValue doubleValue]);
	}
	return [NSString stringWithFormat:@"%@", @(value)];
}

+ (NSString *)applyArithmeticFunction:(BBTemplaterFunctionType)function toValue:(NSString *)value otherValues:(NSArray *)values error:(NSError **)error {
	NSString *result = value;
	if (result) {
		double valueDbl = [result doubleValue];
		for (NSString *oneValue in values) {
			switch (function) {
				case BBTemplaterFunctionTypeAdd:
					valueDbl += [oneValue doubleValue];
					break;
				case BBTemplaterFunctionTypeSub:
					valueDbl -= [oneValue doubleValue];
					break;
				case BBTemplaterFunctionTypeMul:
					valueDbl *= [oneValue doubleValue];
					break;
				case BBTemplaterFunctionTypeDiv:
					valueDbl /= [oneValue doubleValue];
					break;
				default:
					break;
			}
		}
		result = [NSString stringWithFormat:@"%@", @(valueDbl)];
	} else {
		*error = [BBTemplaterErrors invalidFormatError:@"arithmetic function has to have initial value"];
	}
	return result;
}

@end
