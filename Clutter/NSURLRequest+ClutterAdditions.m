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

#import "NSURLRequest+ClutterAdditions.h"

#import "Clutter.h"

@implementation NSURLRequest (ClutterAdditions)

#pragma mark - Description

- (NSString *)description
{
    NSMutableString *s = [NSMutableString string];
    [s appendFormat:@"curl -X %@ ", self.HTTPMethod];
    for (NSString *header in self.allHTTPHeaderFields) {
        [s appendFormat:@"-H \"%@: %@\" ", header, [self valueForHTTPHeaderField:header]];
    }
    [s appendFormat:@"\"%@\"", self.URL];
    return s;
}
@end
