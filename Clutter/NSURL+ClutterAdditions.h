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

@interface NSURL (ClutterAdditions)

/// @name URL Append Query

/// Create a URL by appending ?{query} to it.
/// @warning Does not check that there is not already a query string.
- (NSURL *)URLByAppendingQuery:(NSString *)query;

/// Create a query string from the arguments dictionary, e.g. ?{key1}={value1}&{key1}={value2}, where keys and values are URL encoded, and append it to the url.
/// @warning Does not check that there is not already a query string.
- (NSURL *)URLByAppendingQueryArguments:(NSDictionary *)arguments;


/// @name Path Components

/// URL by appending multiple path components
- (NSURL *)URLByAppendingPathComponents:(NSString *)firstComponent, ... NS_REQUIRES_NIL_TERMINATION;

@end
