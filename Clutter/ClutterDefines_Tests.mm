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

SPEC_BEGIN(MacrosSpec)

describe(@"CLAMP", ^{
    it(@"works", ^{
        [[theValue(CLAMP(0, 1.0, 2.0)) should] equal:theValue(1.0)];
        [[theValue(CLAMP(3, 1.0, 2.0)) should] equal:theValue(2.0)];
    });
});

describe(@"COUNT", ^{
    it(@"works", ^{
        [[@(COUNT()) should] equal:@0];
        [[@(COUNT(a)) should] equal:@1];
        [[@(COUNT(a,b)) should] equal:@2];
    });
});

#define dispatch2(a,b) 2
#define dispatch1(a) 1
#define dispatch0() 0
#define dispatch(...) DISPATCH(dispatch, ##__VA_ARGS__)

describe(@"DISPATCH", ^{
    it(@"works", ^{
        [[@(dispatch()) should] equal:@0];
        [[@(dispatch(a)) should] equal:@1];
        [[@(dispatch(a,b)) should] equal:@2];
    });
});


SPEC_END
