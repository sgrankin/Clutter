//
//  TestNSString.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

#import "CLStateMachine.h"

@protocol CarState <NSObject>
@optional
- (BOOL)isMoving;

// transitions
- (void)ignite;
- (void)gas;
- (void)brake;
- (void)stop;
@end

@interface Car : CLStateMachine <CarState>
@end
@interface CarStopped : CLStateMachineState <CarState>
@end
@interface CarIdling : CLStateMachineState <CarState>
@end
@interface CarMoving : CLStateMachineState <CarState>
@end

@implementation CarStopped
- (BOOL)isMoving { return NO; }
- (void)ignite { [self.stateMachine transitionToState:CarIdling.class]; };
- (void)gas {}
- (void)stop {}
@end

@implementation CarIdling
- (BOOL)isMoving { return NO; }
- (void)gas { [self.stateMachine transitionToState:CarMoving.class]; }
- (void)stop { [self.stateMachine transitionToState:CarStopped.class]; }
@end

@implementation CarMoving
- (BOOL)isMoving { return YES; }
- (void)gas {}
- (void)brake { [self.stateMachine transitionToState:CarIdling.class]; }
- (void)stop { [self.stateMachine transitionToState:CarStopped.class]; }
@end

@implementation Car
- (id)init
{
    if (self = [super initWithStates:@[CarStopped.class, CarIdling.class, CarMoving.class]]) {
    }
    return self;
}
@end

SPEC_BEGIN(CLStateMachineSpec)

describe(@"CLStateMachine", ^{
    Car *car = [Car new];
    it(@"has description", ^{
        [car.description shouldNotBeNil];
    });
    it(@"changes state", ^{
        [[@(car.isMoving) should] beFalse];
        [car ignite];
        [car gas];
        [[@(car.isMoving) should] beTrue];
        [car stop];
        [[@(car.isMoving) should] beFalse];
    });
    it(@"raises on unknown transitions", ^{
        [car ignite];
        [[theBlock(^{
            [car ignite];
        }) should] raise];
    });

});

SPEC_END