//
//  NSURLSpec.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

@interface TestApplicationObserver : NSObject <UIApplicationDelegate>
@end
@implementation TestApplicationObserver
@end

SPEC_BEGIN(UIApplicationSpec)

describe(@"UIApplication", ^{
    describe(@"UIApplicationDelegate observer", ^{
        it(@"can add and remove observers", ^{
            TestApplicationObserver *testObserver = [TestApplicationObserver new];
            [[UIApplication sharedApplication] addObserver:testObserver];
            [[UIApplication sharedApplication] removeObserver:testObserver];
       });
    });
});

SPEC_END