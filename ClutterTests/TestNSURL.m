//
//  NSURLSpec.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(NSURLSpec)

describe(@"NSURL", ^{
    NSURL *rootURL = [NSURL URLWithString:@"http://example.com/foo"];
    
    it(@"URLByAppendingQuery works", ^{
        [[[rootURL URLByAppendingQuery:@"test&test"].absoluteString should] equal:@"http://example.com/foo?test&test"];
    });
    
    it(@"URLByAppendingQueryArguments works", ^{
        [[[rootURL URLByAppendingQueryArguments:@{@"test 1":@"test 2"}].absoluteString should] equal:@"http://example.com/foo?test%201=test%202"];
        [[[rootURL URLByAppendingQueryArguments:@{@1:@2, @" ":@" "}].absoluteString should] equal:@"http://example.com/foo?%20=%20&1=2"];
    });
});

SPEC_END