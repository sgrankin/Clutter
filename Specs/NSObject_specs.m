//
//  ClutterTests.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

@interface KVOTestObject : NSObject
@property NSString *property;
@end
@implementation KVOTestObject
- (void)dealloc
{
    NSLog(@"dealloc!");
}
@end

SPEC_BEGIN(NSObjectSpec)

describe(@"NSObject", ^{
    describe(@"Block-based KVO", ^{
        it(@"can add and remove observers", ^{
            KVOTestObject *object = [KVOTestObject new];
            __block BOOL observed = NO;

            // test add
            [object addObserverForKeyPath:@"property" withBlock:^(id object) {
                observed = YES;
            }];
            object.property = @"poop";
            [[theValue(observed) should] equal:@YES];
            
            // test remove
            observed = NO;
            [object removeObserversForKeyPath:@"property"];
            object.property = @"poop";
            [[theValue(observed) should] equal:@NO];
        });
    });
    
    describe(@"Cast", ^{
        it(@"can downcast", ^{
            NSMutableArray *d = [NSMutableArray array];
            NSArray *b = d;
            d = [NSMutableArray cast:b];
            [d shouldNotBeNil];
        });
        it(@"rejects incompatible types", ^{
            NSMutableArray *a = [NSMutableArray array];
            NSString *s = [NSString cast:a];
            [s shouldBeNil];
        });
    });
});

SPEC_END