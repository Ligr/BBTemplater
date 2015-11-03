//
//  ContextTests.m
//  BalanceBy
//
//  Created by Alex on 7/2/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BBTemplaterContext.h"

@interface ContextTests : XCTestCase {
	BBTemplaterContext *_context;
}

@end

@implementation ContextTests

- (void)setUp {
    [super setUp];
	_context = [[BBTemplaterContext alloc] init];
}

- (void)tearDown {
	_context = nil;
    [super tearDown];
}

- (void)testStoreValue {
	NSString *storedValue = @"test";
	[_context storeValue:storedValue forKey:@"key"];
	NSString *readValue = [_context storedValueForKey:@"key"];
	XCTAssertTrue([storedValue isEqualToString:readValue]);
}

- (void)testStoreVariable {
	NSString *storedVariable = @"test";
	[_context storeValue:storedVariable forVariable:@"key"];
	NSString *readVariable = [_context storedValueForKey:@"var.key"];
	XCTAssertTrue([storedVariable isEqualToString:readVariable]);
}

- (void)testReadMissingValue {
	NSString *value = [_context storedValueForKey:@"key"];
	XCTAssertNil(value);
}

- (void)testReplaceVariable {
	NSString *value = @"111";
	[_context storeValue:value forVariable:@"a"];
	NSString *storedValue = [_context storedValueForKey:@"var.a"];
	XCTAssertTrue([storedValue isEqualToString:value]);
	
	value = @"222";
	[_context storeValue:value forVariable:@"a"];
	storedValue = [_context storedValueForKey:@"var.a"];
	XCTAssertTrue([storedValue isEqualToString:value]);
}

- (void)testAccounts {
	NSString *account = _context.account;
	XCTAssertNil(account);
	[_context pushAccountWithName:@"test"];
	account = _context.account;
	XCTAssertTrue([account isEqualToString:@"test"]);
	[_context pushAccountWithName:@"test2"];
	account = _context.account;
	XCTAssertTrue([account isEqualToString:@"test2"]);
	[_context popAccount];
	account = _context.account;
	XCTAssertTrue([account isEqualToString:@"test"]);
	[_context popAccount];
	account = _context.account;
	XCTAssertNil(account);
}

- (void)testArray {
	NSArray *array = [_context storedValueForKey:@"arr"];
	XCTAssertNil(array);
	[_context addValue:@"123" toArrayWithName:@"arr"];
	array = [_context storedValueForKey:@"arr"];
	XCTAssertNotNil(array);
	XCTAssertTrue(array.count == 1);
	[_context addValue:@"456" toArrayWithName:@"arr"];
	array = [_context storedValueForKey:@"arr"];
	XCTAssertTrue(array.count == 2);
}

@end
