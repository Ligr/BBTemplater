//
//  BBTemplaterContext.m
//  BalanceBy
//
//  Created by Aliaksandr Huryn on 6/29/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "BBTemplaterContext.h"

@interface BBTemplaterContext () {
	BBTemplaterValueProcessor *_valueProcessor;
	NSMutableDictionary *_storage;
	NSMutableDictionary *_outStorage;
	NSMutableArray *_accounts;
	NSMutableArray *_dataStack;
	NSMutableArray *_searchGroupStack;
}

@end

@implementation BBTemplaterContext

- (id)initWithValueProcessor:(BBTemplaterValueProcessor *)processor {
	self = [super init];
	if (self) {
		_valueProcessor = processor;
		[self setup];
	}
	return self;
}

- (id)init {
	self = [self initWithValueProcessor:[BBTemplaterValueProcessor new]];
	if (self) {
		
	}
	return self;
}

- (void)storeValue:(id)value forKey:(NSString *)key {
	if (value) {
		_storage[key] = value;
	} else {
		[_storage removeObjectForKey:key];
	}
#if DEBUG
	if (!key) {
		NSLog(@"[BBTemplaterContext][ERROR]: missing value name");
	}
#endif
}

- (void)storeValues:(NSDictionary *)values {
	for (NSString *key in [values allKeys]) {
		[self storeValue:values[key] forKey:key];
	}
}

- (void)storeValue:(id)value forVariable:(NSString *)variable {
	if (value && variable) {
		_storage[[NSString stringWithFormat:@"var.%@", variable]] = value;
	} else if (variable) {
		[_storage removeObjectForKey:variable];
	}
#if DEBUG
	if (!variable) {
		NSLog(@"[BBTemplaterContext][ERROR]: missing variable name");
	}
#endif
}

- (id)storedValueForKey:(NSString *)key {
	id value = _storage[key];
#if DEBUG
	if (!value) {
		NSLog(@"[BBTemplaterContext][INFO]: missing stored value for key '%@'", key);
	}
#endif
	return value;
}

- (void)pushAccountWithName:(NSString *)name {
	[_accounts addObject:name];
}

- (NSString *)popAccount {
	NSString *name = [_accounts lastObject];
	[_accounts removeLastObject];
	return name;
}

- (NSString *)account {
	return [_accounts lastObject];
}

- (void)addValue:(id)value toArrayWithName:(NSString *)arrayName {
	[self addValue:value toArrayWithName:arrayName storate:_storage];
}

- (void)outValue:(id)value withName:(NSString *)name {
	[self addValue:value toArrayWithName:name storate:_outStorage];
}

- (NSArray *)outValuesWithName:(NSString *)name {
	return _outStorage[name];
}

- (void)registerCallback:(BBTemplaterTag *)callback forName:(NSString *)name {
	[self storeValue:callback forKey:[NSString stringWithFormat:@"callback.%@", name]];
}

- (BBTemplaterTag *)callbackForName:(NSString *)name {
	return (BBTemplaterTag *)[self storedValueForKey:name];
}

- (void)pushData:(id)data {
	if (!data) {
		data = [NSNull null];
	}
	[_dataStack addObject:data];
}

- (void)popData {
	if (_dataStack.count > 0) {
		[_dataStack removeLastObject];
	} else {
		NSLog(@"[ERROR]: trying to pop data from empty data stack");
	}
}

- (id)data {
	id data = [_dataStack lastObject];
	if ([data isEqual:[NSNull null]]) {
		data = nil;
	}
	return data;
}

- (void)pushSearchGroup:(id)data {
	if (!data) {
		data = [NSNull null];
	}
	[_searchGroupStack addObject:data];
}

- (void)popSearchGroup {
	if (_searchGroupStack.count > 0) {
		[_searchGroupStack removeLastObject];
	} else {
		NSLog(@"[ERROR]: trying to pop data from empty search group stack");
	}
}

- (id)searchGroup {
	return [_searchGroupStack lastObject];
}

- (id)evaluateValue:(NSString *)value {
	return [_valueProcessor valueForString:value inContext:self];
}

#pragma mark - Private

- (void)addValue:(id)value toArrayWithName:(NSString *)arrayName storate:(NSMutableDictionary *)storage {
	NSMutableArray *subArray = (NSMutableArray *)storage[arrayName];
	if (!subArray) {
		subArray = [NSMutableArray new];
		storage[arrayName] = subArray;
	}
	[subArray addObject:value];
}

- (void)setup {
	_dataEncoding = NSUTF8StringEncoding;
	_storage = [NSMutableDictionary new];
	_outStorage = [NSMutableDictionary new];
	_accounts = [NSMutableArray new];
	_dataStack = [NSMutableArray new];
	_searchGroupStack = [NSMutableArray new];
	_regexCache = [NSMutableDictionary new];
}

@end
