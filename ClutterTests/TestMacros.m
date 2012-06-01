//
//  ClutterTests.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(MacrosSpec)

describe(@"CLAMP", ^{
    it(@"works", ^{
        [[theValue(CLAMP(1.0, 0.0, 2.0)) should] equal:theValue(1.0)];
        [[theValue(CLAMP(1.0, 3.0, 2.0)) should] equal:theValue(2.0)];
    });
});

SPEC_END