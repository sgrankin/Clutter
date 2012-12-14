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

#include "CLError.h"

/// Log an error.
cl_error_handler_block_t cl_error_log = ^(NSError *error, char const *file, int line, char const *function)
{
    NSLog(@"Error: %@", error);
    DEBUG_BREAK();
};

/// Log an error, printing the source location.
cl_error_handler_block_t cl_error_trace = ^(NSError *error, char const *file, int line, char const *function)
{
    NSLog(@"Error at %s:%d in %s: %@", file, line, function, error);
    DEBUG_BREAK();
};

/// @throw an NSException instance built from an error.
cl_error_handler_block_t cl_error_throw = ^(NSError *error, char const *file, int line, char const *function)
{
    @throw [NSException exceptionWithName:error.localizedDescription
                                   reason:error.localizedFailureReason
                                 userInfo:error.userInfo];
};
