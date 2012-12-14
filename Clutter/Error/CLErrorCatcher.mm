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

#include "CLErrorCatcher.h"

cl_error_catcher::cl_error_catcher(cl_error_handler_t handler, cl_error_context context, NSError * __autoreleasing * pError)
: m_handler(handler), m_context(context), m_pError(pError)
{
    if (!m_pError) {
        // we don't have an autoreleasing pointer, so create one.
        m_pError = new NSError * __autoreleasing(nullptr);
        m_owns_pointer = true;
    }
    m_initial_error = *m_pError;
}

/// Store a __strong pointer; will be assigned to on destruction.
cl_error_catcher::cl_error_catcher(cl_error_handler_t handler, cl_error_context context, NSError * __strong * pError)
: cl_error_catcher(handler, context)
{
    // store the strong pointer separately, and pull out the initial value from there.
    m_spError = pError;
    m_initial_error = *pError;
}

/// Unwrap an __autoreleasing reference.
cl_error_catcher::cl_error_catcher(cl_error_handler_t handler, cl_error_context context, NSError * __autoreleasing &error)
: cl_error_catcher(handler, context, &error)
{
}

/// Unwrap a __strong reference.
cl_error_catcher::cl_error_catcher(cl_error_handler_t handler, cl_error_context context, NSError * __strong &error)
: cl_error_catcher(handler, context, &error)
{
}

/// Handle objective-c block handlers, as they need an explicit copy if they are to be stored.
cl_error_catcher::cl_error_catcher(cl_error_handler_block_t handler, cl_error_context context, NSError * __autoreleasing &error)
: cl_error_catcher(static_cast<cl_error_handler_block_t>([handler copy]), context, &error)
{
}

/// Handle objective-c block handlers, as they need an explicit copy if they are to be stored.
cl_error_catcher::cl_error_catcher(cl_error_handler_block_t handler, cl_error_context context, NSError * __strong &error)
: cl_error_catcher(static_cast<cl_error_handler_block_t>([handler copy]), context, &error)
{
}

// Implicitly convert to pointer to error so that this object can be used in place of &error.
cl_error_catcher::operator NSError * __autoreleasing *()
{
    return m_pError;
}

NSError * __autoreleasing &  cl_error_catcher::operator=(NSError *__autoreleasing error)
{
    *m_pError = error;
    return *m_pError;
}

// Check the error state and run handlers if changed.
cl_error_catcher::~cl_error_catcher() noexcept(false)
{
    NSError *error = *m_pError;
    if (m_spError)
        *m_spError = error; // We had a strong pointer given - make sure it gets the error.


    if (m_owns_pointer)
        delete m_pError; // delete first to avoid leaking on throws

    if (error && m_initial_error != error)
        m_handler(error, m_context.file, m_context.line, m_context.function);
}
