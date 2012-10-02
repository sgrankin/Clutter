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

SPEC_BEGIN(NSStringSpec)

describe(@"NSString", ^{
    describe(@"URL encoding", ^{
        it(@"works", ^{
            NSString *decoded = @"banana ;/?:@&=+$, -_.!~*'()";
            NSString *encoded = [decoded URLEncodedString];
            [[encoded should] equal:@"banana%20%3B%2F%3F%3A%40%26%3D%2B%24%2C%20-_.%21~%2A%27%28%29"];
            [[[encoded URLDecodedString] should] equal:decoded];
        });
    });
});

SPEC_END