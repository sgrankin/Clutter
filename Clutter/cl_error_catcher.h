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

#import <Foundation/Foundation.h>

typedef void (cl_error_handler)(NSError *error, char const *file, int line, char const *function);

typedef void (^cl_error_handler_block)(NSError *error, char const *file, int line, char const *function);

#if defined(__cplusplus)
#include <functional>

/// Generic error-catcher macro.
/// @param handler Error handler of type cl_error_handler or cl_error_handler_block.
/// @param ... Empty or an expression of type: NSError* (__autoreleasing|__strong) *?
#define CL_ERR_CATCH(handler, ...) (cl_error_catcher(handler, {__FILE__, __LINE__, __FUNCTION__}, ##__VA_ARGS__))

// ---- Magic starts here ----

/// Generic NSError pointer wrapper that tracks changes to the pointer over its lifetime
/// and signals a configured handler or changes.
class cl_error_catcher
{
private:
    typedef std::function<cl_error_handler> cl_error_handler_t;
    struct cl_error_context
    {
        char const *file;
        int line;
        char const *function;
    };
    
    cl_error_handler_t m_handler = nil;
    cl_error_context m_context = {};
    
    NSError * __autoreleasing * m_pError = nil; // autoreleasing pointer; may be heap allocated and owned by us.
    NSError * __strong * m_spError = nil; // strong pointer, if we were constructed with one.
    NSError * m_initial_error = nil; // initial value of whatever was given to us.
    
    bool m_owns_pointer = false; /// delete m_pError on destruction?
    
    // NOTE: Any conversion from __strong to __autorelease creates a transient __autorelease object.
    // Do NOT store pointers to these!
    
public:
    /// Store or create an __autoreleasing pointer; will be checked on destruction.
    cl_error_catcher(cl_error_handler_t handler, cl_error_context context, NSError * __autoreleasing * pError = nil);
    
    /// Store a __strong pointer; will be assigned to on destruction.
    cl_error_catcher(cl_error_handler_t handler, cl_error_context context, NSError * __strong * pError);
    
    /// Unwrap an __autoreleasing reference.
    cl_error_catcher(cl_error_handler_t handler, cl_error_context context, NSError * __autoreleasing &error);
    
    /// Unwrap a __strong reference.
    cl_error_catcher(cl_error_handler_t handler, cl_error_context context, NSError * __strong &error);
    
    /// Handle objective-c block handlers, as they need an explicit copy if they are to be stored.
    cl_error_catcher(cl_error_handler_block handler, cl_error_context context, NSError * __autoreleasing &error);
    
    /// Handle objective-c block handlers, as they need an explicit copy if they are to be stored.
    cl_error_catcher(cl_error_handler_block handler, cl_error_context context, NSError * __strong &error);
    
    cl_error_catcher(cl_error_catcher &&) = delete;
    cl_error_catcher(cl_error_catcher const &) = delete;
    
    // Implicitly convert to pointer to error so that this object can be used in place of &error.
    operator NSError * __autoreleasing *();
    
    // Check the error state and run handlers if changed.
    ~cl_error_catcher() noexcept(false);
};

#endif
