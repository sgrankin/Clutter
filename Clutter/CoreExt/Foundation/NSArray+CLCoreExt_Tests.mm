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

SPEC_BEGIN(NSArraySpec)

describe(@"NSArray", ^{
    describe(@"firstObject", ^{
        it(@"works", ^{
            [[@[] firstObject] shouldBeNil];
            [[[@[@1] firstObject] should] equal:@1];
            [[[@[@1, @2] firstObject] should] equal:@1];
        });
    });
    
    describe(@"mappedArrayUsingBlock", ^{
        it(@"works", ^{
            [[[@[@1, @2] mappedArrayUsingBlock:^(NSNumber *obj) { return obj.description; }] should] equal:@[@"1", @"2"]];
        });
    });
    
    describe(@"filteredArrayUsingBlock", ^{
        it(@"works", ^{
            [[[@[@1, @2, @3, @4] filteredArrayUsingBlock:^BOOL(NSNumber *obj) {
                return [obj intValue] % 2 == 0;
            }] should] equal:@[@2, @4]];
        });
    });
    
    describe(@"sortedArrayWithKey", ^{
       it(@"works", ^{
           [[[@[@2, @1, @10] sortedArrayWithKey:@"stringValue" ascending:NO] should] equal:@[@2, @10, @1]];
           [[[@[@2, @1, @10] sortedArrayWithKey:@"stringValue" ascending:YES] should] equal:@[@1, @10, @2]];

       });
        it(@"works withComparator", ^{
            NSComparator c = ^(NSString *a, NSString *b) {
                return [a compare:b];
            };
            [[[@[@2, @1, @10] sortedArrayWithKey:@"stringValue" ascending:NO comparator:c] should] equal:@[@2, @10, @1]];
            [[[@[@2, @1, @10] sortedArrayWithKey:@"stringValue" ascending:YES comparator:c] should] equal:@[@1, @10, @2]];
        });
        it(@"works withSelector", ^{
            SEL s = @selector(caseInsensitiveCompare:);
            [[[@[@2, @1, @10] sortedArrayWithKey:@"stringValue" ascending:NO selector:s] should] equal:@[@2, @10, @1]];
            [[[@[@2, @1, @10] sortedArrayWithKey:@"stringValue" ascending:YES selector:s] should] equal:@[@1, @10, @2]];
            
            [[[@[@"aa", @"AB"] sortedArrayWithKey:@"copy" ascending:YES] should] equal:@[@"AB", @"aa"]];
            [[[@[@"aa", @"AB"] sortedArrayWithKey:@"copy" ascending:YES selector:s] should] equal:@[@"aa", @"AB"]];
        });
    });
    
    describe(@"reverse", ^{
        it(@"works", ^{
            [[[@[@1, @2, @3] reversedArray] should] equal:@[@3, @2, @1]];
        });
    });
    
    describe(@"reduce", ^{
        it(@"works", ^{
            [[[@[@"1", @"2", @"3"] reduceWithInitialValue:@"0" block:^id(id obj1, id obj2) {
                return [obj1 stringByAppendingString:obj2];
            }] should] equal:@"0123"];
        });
    });
});

SPEC_END