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
#import "BBTemplaterContext.h"

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
	NSString *res = [context evaluateValue:@"test"];
	XCTAssertTrue([res isEqualToString:@"test"]);
}

- (void)testArray {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	[context addValue:@"val1" toArrayWithName:@"arr"];
	[context addValue:@"val2" toArrayWithName:@"arr"];
	[context addValue:@"val3" toArrayWithName:@"arr"];
	NSString *res = [context evaluateValue:@"${arr.1}"];
	XCTAssertTrue([res isEqualToString:@"val2"]);
}

- (void)testResult {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	NSArray *data = @[@"val1", @"val2", @"val3"];
	[context pushData:data];
	NSString *res = [context evaluateValue:@"${result.2}"];
	XCTAssertTrue([res isEqualToString:@"val2"]);
	res = [context evaluateValue:@"${result.length}"];
	XCTAssertTrue([res isEqualToString:@"3"]);
	res = [context evaluateValue:@"${result.4}"];
	XCTAssertNil(res);
	res = [context evaluateValue:@"${array.1}"];
	XCTAssertNil(res);
}

- (void)testGroup {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	NSArray *data = @[@"val1", @"val2", @"val3"];
	[context pushSearchGroup:data];
	NSString *res = [context evaluateValue:@"${group.1}"];
	XCTAssertTrue([res isEqualToString:@"val2"]);
	res = [context evaluateValue:@"${group.length}"];
	XCTAssertTrue([res isEqualToString:@"3"]);
	res = [context evaluateValue:@"${group.3}"];
	XCTAssertNil(res);
	res = [context evaluateValue:@"${array.1}"];
	XCTAssertNil(res);
}

- (void)testPhoneBY {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	[context storeValue:@"+375 29 7766555" forKey:@"account.login"];
	NSString *res = [context evaluateValue:@"${phone.countryBY}"];
	XCTAssertTrue([res isEqualToString:@"375"]);
	res = [context evaluateValue:@"${phone.codeBY}"];
	XCTAssertTrue([res isEqualToString:@"29"]);
	res = [context evaluateValue:@"${phone.numberBY}"];
	XCTAssertTrue([res isEqualToString:@"7766555"]);
}

- (void)testFunction {
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	NSString *res = [context evaluateValue:@"${function.time}"];
	XCTAssertNotNil(res);
}

@end
