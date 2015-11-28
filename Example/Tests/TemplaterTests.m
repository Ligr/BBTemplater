//
//  TemplaterTests.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 7/13/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BBTemplater.h"
#import "BBTemplaterTag.h"

@interface TemplaterTests : XCTestCase

@end

@implementation TemplaterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRegisterTag {
	XCTestExpectation *expectation = [self expectationWithDescription:@"parser"];
	NSString *template = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<tst />";
	BBTemplater *templater = [[BBTemplater alloc] initWithTemplate:template data:nil];
	[templater process:^(NSError *error) {
		XCTAssertNotNil(error);
		BBTemplater *templater2 = [[BBTemplater alloc] initWithTemplate:template data:nil];
		[templater2 registerTag:[BBTemplaterTag class] withName:@"tst"];
		[templater2 process:^(NSError *error) {
			XCTAssertNil(error);
			[expectation fulfill];
		}];
	}];
	
	[self waitForExpectationsWithTimeout:60 handler:nil];
}

//- (void)testTemplater {
//	XCTestExpectation *expectation = [self expectationWithDescription:@"parser"];
//	NSError *error = nil;
//	NSString *data = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"inet_by_byfly" ofType:@"xml"] encoding:NSUTF8StringEncoding error:&error];
//	BBTemplater *templater = [[BBTemplater alloc] initWithData:data];
//	[templater registerVariables:@{@"account.login": @"1", @"account.password": @"1"}];
//	[templater process:^(NSError *error) {
//		XCTAssertNil(error);
//		[expectation fulfill];
//		XCTAssertNotNil(templater);
//	}];
//	[self waitForExpectationsWithTimeout:60 handler:nil];
//}
//
//- (void)testTemplaterAkado {
//	XCTestExpectation *expectation = [self expectationWithDescription:@"parser"];
//	NSError *error = nil;
//	NSString *data = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"inet_ru_akado_ural" ofType:@"xml"] encoding:NSUTF8StringEncoding error:&error];
//	BBTemplater *templater = [[BBTemplater alloc] initWithData:data];
//	[templater registerVariables:@{@"account.login": @"f112374", @"account.password": @"286933a"}];
//	[templater process:^(NSError *error) {
//		XCTAssertNil(error);
//		[expectation fulfill];
//		XCTAssertNotNil(templater);
//	}];
//	[self waitForExpectationsWithTimeout:60 handler:nil];
//}
//
//- (void)testTemplaterMts {
//	XCTestExpectation *expectation = [self expectationWithDescription:@"parser"];
//	NSError *error = nil;
//	NSString *data = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"tel_by_mts" ofType:@"xml"] encoding:NSUTF8StringEncoding error:&error];
//	BBTemplater *templater = [[BBTemplater alloc] initWithData:data];
//	[templater registerVariables:@{@"account.login": @"+375298676444", @"account.password": @"71727"}];
//	[templater process:^(NSError *error) {
//		XCTAssertNil(error);
//		[expectation fulfill];
//		XCTAssertNotNil(templater);
//	}];
//	[self waitForExpectationsWithTimeout:60 handler:nil];
//}
//
//- (void)testTemplaterVelcom {
//	XCTestExpectation *expectation = [self expectationWithDescription:@"parser"];
//	NSError *error = nil;
//	NSString *data = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"tel_by_velcom" ofType:@"xml"] encoding:NSUTF8StringEncoding error:&error];
//	BBTemplater *templater = [[BBTemplater alloc] initWithData:data];
//	[templater registerVariables:@{@"account.login": @"+37529 6914075", @"account.password": @"77031691"}];
//	[templater process:^(NSError *error) {
//		XCTAssertNil(error);
//		[expectation fulfill];
//		XCTAssertNotNil(templater);
//	}];
//	[self waitForExpectationsWithTimeout:60 handler:nil];
//}
//
//- (void)testTemplaterTelPlPlay {
//	XCTestExpectation *expectation = [self expectationWithDescription:@"parser"];
//	NSError *error = nil;
//	NSString *data = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"tel_pl_play" ofType:@"xml"] encoding:NSUTF8StringEncoding error:&error];
//	BBTemplater *templater = [[BBTemplater alloc] initWithData:data];
//	[templater registerVariables:@{@"account.login": @"609530145", @"account.password": @"Gumiszip02"}];
//	[templater process:^(NSError *error) {
//		XCTAssertNil(error);
//		[expectation fulfill];
//		XCTAssertNotNil(templater);
//	}];
//	[self waitForExpectationsWithTimeout:60 handler:nil];
//}
//
//- (void)testTemplaterS13 {
//	XCTestExpectation *expectation = [self expectationWithDescription:@"parser"];
//	NSError *error = nil;
//	NSString *data = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"s13" ofType:@"xml"] encoding:NSUTF8StringEncoding error:&error];
//	BBTemplater *templater = [[BBTemplater alloc] initWithData:data];
//	[templater process:^(NSError *error) {
//		XCTAssertNil(error);
//		NSArray *news = [templater outValuesWithName:@"news"];
//		XCTAssertNotNil(news);
//		XCTAssertTrue(news.count > 0);
//		[expectation fulfill];
//	}];
//	[self waitForExpectationsWithTimeout:60 handler:nil];
//}
//
//- (void)testTemplaterS13Detail {
//	XCTestExpectation *expectation = [self expectationWithDescription:@"parser"];
//	NSError *error = nil;
//	NSString *data = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"s13_detail" ofType:@"xml"] encoding:NSUTF8StringEncoding error:&error];
//	BBTemplater *templater = [[BBTemplater alloc] initWithData:data];
//	[templater registerVariables:@{@"url": @"http://s13.ru/archives/113677"}];
//	[templater process:^(NSError *error) {
//		XCTAssertNil(error);
//		NSArray *text = [templater outValuesWithName:@"text"];
//		XCTAssertNotNil(text);
//		XCTAssertTrue(text.count == 1);
//		[expectation fulfill];
//	}];
//	[self waitForExpectationsWithTimeout:60 handler:nil];
//}

@end
