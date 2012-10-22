// Copyright (c) 2012 Sergey Grankin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

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