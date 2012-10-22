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
#import "CLStateMachineState.h"
#import "NSArray+ClutterAdditions.h"

@interface CLStateMachine ()
@property NSDictionary *statesByClass;
@property CLStateMachineState *currentState;
@end

@implementation CLStateMachine
- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithStates:(NSArray *)states
{
    if (self = [super init]) {
        NSMutableDictionary *statesByClass = [NSMutableDictionary dictionary];
        for (Class c in states) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
            statesByClass[c] = [self stateForStateClass:c];
#pragma clang diagnostic pop
        }
        self.statesByClass = statesByClass;
        self.currentState = self.statesByClass[states.firstObject];
        NSLog(@"%@ currentState:%@", self.class, self.currentState.class);
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@[%@]", self.class, self.currentState.class];
}

- (CLStateMachineState *)stateForStateClass:(Class)class
{
    return [[class alloc] initWithStateMachine:self];
}

- (void)transitionToState:(Class)state
{
    NSLog(@"%@ currentState:%@->%@", self.class, self.currentState.class, state);
    CLStateMachineState *originalState = self.currentState;
    CLStateMachineState *newState = self.statesByClass[state];
    [self.currentState willTransitionToState:newState];
    self.currentState = newState;
    [self.currentState didTransitionFromState:originalState];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [self.currentState methodSignatureForSelector:aSelector];
    if (!sig)
        sig = [super methodSignatureForSelector:aSelector];
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.currentState respondsToSelector:anInvocation.selector])
        [anInvocation invokeWithTarget:self.currentState];
    else
        [super forwardInvocation:anInvocation];
}
@end
