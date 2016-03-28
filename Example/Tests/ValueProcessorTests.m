//
//  ValueProcessorTests.m
//  BalanceBy
//
//  Created by Alex on 8/6/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BBTemplaterValueProcessor.h"

@interface ValueProcessorTests : XCTestCase

@end

@implementation ValueProcessorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimpleValue {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	NSString *res = [[BBTemplaterValueProcessor instance] valueForString:@"test" inContext:context];
	XCTAssertTrue([res isEqualToString:@"test"]);
}

- (void)testArray {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	[context addValue:@"val1" toArrayWithName:@"arr"];
	[context addValue:@"val2" toArrayWithName:@"arr"];
	[context addValue:@"val3" toArrayWithName:@"arr"];
	NSString *res = [[BBTemplaterValueProcessor instance] valueForString:@"${arr.1}" inContext:context];
	XCTAssertTrue([res isEqualToString:@"val2"]);
}

- (void)testResult {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	NSArray *data = @[@"val1", @"val2", @"val3"];
	[context pushData:data];
	NSString *res = [[BBTemplaterValueProcessor instance] valueForString:@"${result.1}" inContext:context];
	XCTAssertTrue([res isEqualToString:@"val2"]);
	res = [[BBTemplaterValueProcessor instance] valueForString:@"${result.length}" inContext:context];
	XCTAssertTrue([res isEqualToString:@"3"]);
	res = [[BBTemplaterValueProcessor instance] valueForString:@"${result.3}" inContext:context];
	XCTAssertNil(res);
	res = [[BBTemplaterValueProcessor instance] valueForString:@"${array.1}" inContext:context];
	XCTAssertNil(res);
}

- (void)testGroup {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	NSArray *data = @[@"val1", @"val2", @"val3"];
	[context pushSearchGroup:data];
	NSString *res = [[BBTemplaterValueProcessor instance] valueForString:@"${group.1}" inContext:context];
	XCTAssertTrue([res isEqualToString:@"val2"]);
	res = [[BBTemplaterValueProcessor instance] valueForString:@"${group.length}" inContext:context];
	XCTAssertTrue([res isEqualToString:@"3"]);
	res = [[BBTemplaterValueProcessor instance] valueForString:@"${group.3}" inContext:context];
	XCTAssertNil(res);
	res = [[BBTemplaterValueProcessor instance] valueForString:@"${array.1}" inContext:context];
	XCTAssertNil(res);
}

- (void)testPhoneBY {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	[context storeValue:@"+375 29 7766555" forKey:@"account.login"];
	NSString *res = [[BBTemplaterValueProcessor instance] valueForString:@"${phone.countryBY}" inContext:context];
	XCTAssertTrue([res isEqualToString:@"375"]);
	res = [[BBTemplaterValueProcessor instance] valueForString:@"${phone.codeBY}" inContext:context];
	XCTAssertTrue([res isEqualToString:@"297"]);
	res = [[BBTemplaterValueProcessor instance] valueForString:@"${phone.numberBY}" inContext:context];
	XCTAssertTrue([res isEqualToString:@"766555"]);
}

- (void)testFunction {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	NSString *res = [[BBTemplaterValueProcessor instance] valueForString:@"${function.time}" inContext:context];
	XCTAssertNotNil(res);
}

@end
