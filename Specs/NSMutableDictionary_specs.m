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

SPEC_BEGIN(NSMutableDictionarySpec)

describe(@"NSMutableDictionary", ^{
    describe(@"objectForKey:withInitializer:", ^{
        it(@"works", ^{
            NSMutableDictionary *d = [NSMutableDictionary dictionary];
            NSString *key = @"key";
            NSString *val = @"val";
            [d[key] shouldBeNil];
            
            // nil initializer will return nil
            [[d objectForKey:key withInitializer:^id{
                return nil;
            }] shouldBeNil];
            
            // nil initializer will not assign anything
            [d[key] shouldBeNil];
            
            // initializer should return value
            [[[d objectForKey:key withInitializer:^id{
                return val;
            }] should] equal:val];
            
            // value should be set by initializer
            [[d[key] should] equal:val];
            
            NSString *otherVal = @"otherval";
            // initializer should not be rerun
            [[[d objectForKey:key withInitializer:^id{
                return otherVal;
            }] should] equal:val];
            [[d[key] should] equal:val];
        });
    });
});

SPEC_END