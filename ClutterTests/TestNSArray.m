//
//  TestNSString.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(NSArraySpec)

describe(@"NSArray", ^{
    describe(@"firstObject", ^{
        it(@"works", ^{
            [[@[] firstObject] shouldBeNil];
            [[[@[@1] firstObject] should] equal:@1];
            [[[@[@1, @2] firstObject] should] equal:@1];
        });
    });
    
    describe(@"mappedArrayUsingBlock", ^{
        it(@"works", ^{
            [[[@[@1, @2] mappedArrayUsingBlock:^(NSNumber *obj) { return obj.description; }] should] equal:@[@"1", @"2"]];
        });
    });
});

SPEC_END