//
//  TagTests.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 8/7/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BBTemplaterTagProvider.h"
#import "BBTemplaterTagSearch.h"
#import "BBTemplaterTagVar.h"
#import "BBTemplaterTagsProcessor.h"

@interface TagTests : XCTestCase

@end

@implementation TagTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTagProvider {
	XCTestExpectation *expectation = [self expectationWithDescription:@"tag"];
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	BBTemplaterTagProvider *tag = [[BBTemplaterTagProvider alloc] initWithAttributes:@{@"url": @"https://test.com"} context:context];
	[tag process:^(id data, NSError *error) {
		[expectation fulfill];
		XCTAssertNil(error);
		NSString *url = [context storedValueForKey:@"provider.url"];
		XCTAssertNotNil(url);
		XCTAssertEqualObjects(url, @"https://test.com");
	}];
	[self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testSearchGroup {
	XCTestExpectation *expectation = [self expectationWithDescription:@"tag"];
	BBTemplaterContext *context = [[BBTemplaterContext alloc] init];
	BBTemplaterTagSearch *tagSearch = [[BBTemplaterTagSearch alloc] initWithAttributes:@{@"value": @"a123b", @"regex": @"a([\\d]*)b"} context:context];
	BBTemplaterTagVar *tagVar = [[BBTemplaterTagVar alloc] initWithAttributes:@{@"name": @"res", @"value": @"${group.1}"} context:context];
	[tagSearch addSubtag:tagVar];
	BBTemplaterTagsProcessor *processor = [[BBTemplaterTagsProcessor alloc] initWithTag:tagSearch data:nil];
	[processor process:^(NSError *error) {
		[expectation fulfill];
		XCTAssertNil(error);
		NSString *res = [context storedValueForKey:@"var.res"];
		XCTAssertNotNil(res);
		XCTAssertEqualObjects(res, @"123");
	}];
	[self waitForExpectationsWithTimeout:60 handler:nil];
}

@end
