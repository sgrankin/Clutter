//
//  ClutterTests.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(TestSpec)

describe(@"clutter", ^{
    it(@"has tests", ^{
        [[theValue(1) should] equal:theValue(1)];
    });
});

SPEC_END