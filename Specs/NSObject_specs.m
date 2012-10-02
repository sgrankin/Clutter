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