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

SPEC_BEGIN(NSURLSpec)

describe(@"NSURL", ^{
    NSURL *rootURL = [NSURL URLWithString:@"http://example.com/foo"];
    
    it(@"URLByAppendingQuery works", ^{
        [[[rootURL URLByAppendingQuery:@"test&test"].absoluteString should] equal:@"http://example.com/foo?test&test"];
    });
    
    it(@"URLByAppendingQueryArguments works", ^{
        [[[rootURL URLByAppendingQueryArguments:@{@"test 1":@"test 2"}].absoluteString should] equal:@"http://example.com/foo?test%201=test%202"];
        [[[rootURL URLByAppendingQueryArguments:@{@1:@2, @" ":@" "}].absoluteString should] equal:@"http://example.com/foo?%20=%20&1=2"];
    });
});

SPEC_END