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

#import <Foundation/Foundation.h>

#import "CLStateMachineState.h"

/// A CLStateMachine is a container of states and a manager of transitions between them.
/// Any unknown methods called on CLStateMachine will be forwarded to its current state.
@interface CLStateMachine : NSObject

/// Create state machine with a list of states.
/// A state is a Class deriving from CLStateMachineState. The first state specified will be the initial state.
/// This is the designated initializer.
- (id)initWithStates:(NSArray *)states;

/// Initialize a CLStateMachineState. Default implementation will call CLStateMachineState/-initWithStateMachine:
- (CLStateMachineState *)stateForStateClass:(Class)class;

/// Transition the state machine to the new state.
- (void)transitionToState:(Class)state;

/// The current state.
@property (readonly) CLStateMachineState *currentState;
@end

