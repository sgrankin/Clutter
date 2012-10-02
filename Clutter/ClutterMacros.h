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

#ifndef Clutter_ClutterMacros_h
#define Clutter_ClutterMacros_h

#pragma mark - math

/// Constrain the value of x to the [min,max] range.
#define CLAMP(x, min, max) MAX((min), MIN((max), (x)))

/// Paste 2 tokens
#define PASTE(x,y) PASTE_(x,y)
#define PASTE_(x,y) x##y

/// Count the number of arguments (up to 10)
#define COUNT(...) COUNT_(X, ##__VA_ARGS__, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
#define COUNT_(_X, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, N, ...) N

/// Dispatch a macro function based on count of argument, e.g max -> max0, max1, etc.)
#define DISPATCH(func, ...) PASTE(func, COUNT(__VA_ARGS__))(__VA_ARGS__ )

#endif
