//
//  TestNSString.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(NSStringSpec)

describe(@"NSString", ^{
    describe(@"URL encoding", ^{
        it(@"works", ^{
            NSString *decoded = @"banana ;/?:@&=+$, -_.!~*'()";
            NSString *encoded = [decoded URLEncodedString];
            [[encoded should] equal:@"banana%20%3B%2F%3F%3A%40%26%3D%2B%24%2C%20-_.%21~%2A%27%28%29"];
            [[[encoded URLDecodedString] should] equal:decoded];
        });
    });
});

SPEC_END