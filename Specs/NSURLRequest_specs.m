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

SPEC_BEGIN(NSURLRequestSpec)

describe(@"NSURLRequest", ^{
    describe(@"-description", ^{
        it(@"describes a url", ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
            [[request.description should] equal:@"curl -X GET \"http://example.com\""];
        });
    });
});

describe(@"NSMutableURLRequest", ^{
    describe(@"-description", ^{
        it(@"described a url with headers", ^{
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
            [request addValue:@"banana" forHTTPHeaderField:@"Banana"];
            [[request.description should] equal:@"curl -X GET -H \"Banana: banana\" \"http://example.com\""];
        });
    });
});

SPEC_END