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

#import "CLUserDefaults.h"

#import "A2DynamicDelegate.h"

@interface Settings : CLUserDefaults
@property id p1;
@property BOOL p2;
@property NSInteger p3;
@property float p4;
@property double p5;
@property char * p6;
@end

@implementation Settings
@dynamic p1;
@dynamic p2;
@dynamic p3;
@dynamic p4;
@dynamic p5;
@dynamic p6;
@end

SPEC_BEGIN(CLUserDefaultsSpec)

describe(@"CLUserDefaults", ^{
    Settings *s = [Settings new];
    
    it(@"works for objects", ^{
#define TEST_PROP(PNAME, PVAL) s.PNAME = PVAL; [[s.PNAME should] equal:PVAL];
        TEST_PROP(p1, @{@"key":@2});
#undef TEST_PROP
    });
    
    it(@"works for known primitive types", ^{
#define TEST_PROP(PNAME, PVAL) s.PNAME = PVAL; [[@(s.PNAME) should] equal:@(PVAL)];
        TEST_PROP(p2, YES);
        TEST_PROP(p3, 42);
        TEST_PROP(p4, FLT_EPSILON);
        TEST_PROP(p5, DBL_EPSILON);
#undef TEST_PROP
    });
    
    it (@"fails for unknown primitive types", ^{
        [[theBlock(^{
            s.p6 = NULL;
        }) should] raise];
    });
    
    it (@"Notifies self of changes", ^{
        [[[s should] receive] didChangeValueForKey:@"p1"];
        s.p1 = @{@"bar": @0};
    });
    
    it (@"Notifies delegate of changes", ^{
        A2DynamicDelegate<CLUserDefaultsDelegate> *delegate = [s dynamicDelegateForProtocol:@protocol(CLUserDefaultsDelegate)];
        __block BOOL received = NO;
        [delegate implementMethod:@selector(userDefaultsDidChange:) withBlock:^{
            received = YES;
        }];
        s.delegate = delegate;
        [[[delegate should] receive] userDefaultsDidChange:s];
        s.p1 = @"hello";
        s.delegate = nil;
    });
    
    it (@"Sends notification", ^{
        // Mock in a description method as the notification receiver, since we don't have a type compatible one sitting about.
        
        id receiver = [NSObject mock];
        [[receiver stub] description];
        [[receiver should] receive:@selector(description)];
        
        [[NSNotificationCenter defaultCenter] addObserver:receiver
                                                 selector:@selector(description)
                                                     name:CLUserDefaultsDidChangeNotification
                                                   object:s];
        s.p1 = @"world";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CLUserDefaultsDidChangeNotification object:s];
    });
});

SPEC_END
