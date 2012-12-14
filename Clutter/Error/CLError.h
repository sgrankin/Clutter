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

#pragma once
#import "ClutterDefines.h"

#if defined(__cplusplus)
#import "CLErrorCatcher.h"

/** @group Default logging methods.
 
 Suggested usage:
 #if DEBUG
 #define ERROR(...) ERR_THROW(__VA_ARGS__)
 #else
 #define ERROR(...) ERR_LOG(__VA_ARGS__)
 #endif
 */

/// Log an error.
extern cl_error_handler_block_t cl_error_log;;

/// Log an error, printing the source location.
extern cl_error_handler_block_t cl_error_trace;;

/// @throw an NSException instance built from an error.
extern cl_error_handler_block_t cl_error_throw;;

#if !defined(CLUTTER_NO_ERR_MACROS)
#define ERR_LOG(...)   CL_ERR_CATCH(cl_error_log, ##__VA_ARGS__)
#define ERR_TRACE(...) CL_ERR_CATCH(cl_error_trace, ##__VA_ARGS__)
#define ERR_THROW(...) CL_ERR_CATCH(cl_error_throw, ##__VA_ARGS__)
#endif

#endif // defined(__cplusplus)
