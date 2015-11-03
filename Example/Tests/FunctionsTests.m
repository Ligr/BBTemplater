//
//  FunctionsTests.m
//  BalanceBy
//
//  Created by Alex on 7/4/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BBTemplaterFunctions.h"
#import "BBTemplaterErrors.h"

@interface FunctionsTests : XCTestCase

@end

@implementation FunctionsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAdd {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"add,10" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"110"]);
}

- (void)testAddMultiple {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"add,10,1" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"111"]);
}

- (void)testAddError {
	NSString *value = @"100";
	NSError *error = nil;
	[BBTemplaterFunctions calculateValue:value withFunctionDetails:@"add" error:&error];
	XCTAssertNotNil(error);
	XCTAssertEqual(error.code, BB_EC_INVALID_FORMAT);
}

- (void)testSub {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"sub,10" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"90"]);
}

- (void)testSubMultiple {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"sub,10,1" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"89"]);
}

- (void)testSubError {
	NSString *value = @"100";
	NSError *error = nil;
	[BBTemplaterFunctions calculateValue:value withFunctionDetails:@"sub" error:&error];
	XCTAssertNotNil(error);
	XCTAssertEqual(error.code, BB_EC_INVALID_FORMAT);
}

- (void)testMul {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"mul,10" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"1000"]);
}

- (void)testMulMultiple {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"mul,10,2" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"2000"]);
}

- (void)testMulError {
	NSString *value = @"100";
	NSError *error = nil;
	[BBTemplaterFunctions calculateValue:value withFunctionDetails:@"mul" error:&error];
	XCTAssertNotNil(error);
	XCTAssertEqual(error.code, BB_EC_INVALID_FORMAT);
}

- (void)testDiv {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"div,2" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"50"]);
}

- (void)testDivMultiple {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"div,10,2" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"5"]);
}

- (void)testDivError {
	NSString *value = @"100";
	NSError *error = nil;
	[BBTemplaterFunctions calculateValue:value withFunctionDetails:@"div" error:&error];
	XCTAssertNotNil(error);
	XCTAssertEqual(error.code, BB_EC_INVALID_FORMAT);
}

- (void)testMin {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"min,2" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"2"]);
}

- (void)testMinMultiple {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"min,10,2,5" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"2"]);
}

- (void)testMinError {
	NSString *value = @"100";
	NSError *error = nil;
	[BBTemplaterFunctions calculateValue:value withFunctionDetails:@"min" error:&error];
	XCTAssertNotNil(error);
	XCTAssertEqual(error.code, BB_EC_INVALID_FORMAT);
}

- (void)testMax {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"max,2" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"100"]);
}

- (void)testMaxMultiple {
	NSString *value = @"100";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"max,10,200,5" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"200"]);
}

- (void)testMaxError {
	NSString *value = @"100";
	NSError *error = nil;
	[BBTemplaterFunctions calculateValue:value withFunctionDetails:@"max" error:&error];
	XCTAssertNotNil(error);
	XCTAssertEqual(error.code, BB_EC_INVALID_FORMAT);
}

- (void)testIndex {
	NSArray *values = @[@"1", @"2", @"3"];
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:values withFunctionDetails:@"index,1" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"2"]);
}

- (void)testIndexError {
	NSArray *values = @[@"1", @"2", @"3"];
	NSError *error = nil;
	[BBTemplaterFunctions calculateValue:values withFunctionDetails:@"index" error:&error];
	XCTAssertNotNil(error);
	XCTAssertEqual(error.code, BB_EC_INVALID_FORMAT);
	
	error = nil;
	[BBTemplaterFunctions calculateValue:values withFunctionDetails:@"index,3" error:&error];
	XCTAssertNotNil(error);
	XCTAssertEqual(error.code, BB_EC_INVALID_PARAMETER);
}

- (void)testHmacSHA1 {
	NSString *value = @"11111111";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"HmacSHA1,222,hex" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"63195d5e7fa11098cfc6a9cd7272e644e7046802"]);
}

- (void)testEncryptMD5 {
	NSString *value = @"11111111";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"encrypt,MD5,hex" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"1bbd886460827015e5d605ed44252251"]);
}

- (void)testEncryptMD5Base64 {
	NSString *value = @"11111111";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"encrypt,MD5,base64" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"G72IZGCCcBXl1gXtRCUiUQ=="]);
}

- (void)testEncryptSHA1 {
	NSString *value = @"11111111";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"encrypt,SHA-1,hex" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"a642a77abd7d4f51bf9226ceaf891fcbb5b299b8"]);
}

- (void)testEncryptSHA256 {
	NSString *value = @"11111111";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"encrypt,SHA-256,hex" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"ee79976c9380d5e337fc1c095ece8c8f22f91f306ceeb161fa51fecede2c4ba1"]);
}

- (void)testEncryptSHA512 {
	NSString *value = @"11111111";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"encrypt,SHA-512,hex" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"62670d1e1eea06b6c975e12bc8a16131b278f6d7bcbe017b65f854c58476baba86c2082b259fd0c1310935b365dc40f609971b6810b065e528b0b60119e69f61"]);
}

- (void)testEncryptError {
	NSString *value = @"11111111";
	NSError *error = nil;
	[BBTemplaterFunctions calculateValue:value withFunctionDetails:@"encrypt" error:&error];
	XCTAssertNotNil(error);
	XCTAssertEqual(error.code, BB_EC_INVALID_FORMAT);
	
	error = nil;
	[BBTemplaterFunctions calculateValue:value withFunctionDetails:@"encrypt,SHA-XXX,hex" error:&error];
	XCTAssertNotNil(error);
	XCTAssertEqual(error.code, BB_EC_INVALID_PARAMETER);
}

- (void)testPKCS5 {
	NSString *value = @"11111111";
	NSError *error = nil;
	NSString *result = [BBTemplaterFunctions calculateValue:value withFunctionDetails:@"PKCS5,MjIy,MzMz,hex" error:&error];
	XCTAssertNil(error);
	XCTAssertTrue([result isEqualToString:@"d75d75d75d750a0a0a0a0a0a0a0a0a0a"]);
}

@end
