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
        [[theValue(CLAMP(0, 1.0, 2.0)) should] equal:theValue(1.0)];
        [[theValue(CLAMP(3, 1.0, 2.0)) should] equal:theValue(2.0)];
    });
});

describe(@"COUNT", ^{
    it(@"works", ^{
        [[@(COUNT()) should] equal:@0];
        [[@(COUNT(a)) should] equal:@1];
        [[@(COUNT(a,b)) should] equal:@2];
    });
});

#define dispatch2(a,b) 2
#define dispatch1(a) 1
#define dispatch0() 0
#define dispatch(...) DISPATCH(dispatch, ##__VA_ARGS__)

describe(@"DISPATCH", ^{
    it(@"works", ^{
        [[@(dispatch()) should] equal:@0];
        [[@(dispatch(a)) should] equal:@1];
        [[@(dispatch(a,b)) should] equal:@2];
    });
});


SPEC_END
