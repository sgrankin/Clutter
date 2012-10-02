//
//  cl_error_catcher.cpp
//  Clutter
//
//  Created by Sergey Grankin on 2012-10-01.
//  Copyright (c) 2012 Apis Amens. All rights reserved.
//

#include "cl_error_catcher.h"

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
cl_error_catcher::cl_error_catcher(cl_error_handler_block handler, cl_error_context context, NSError * __autoreleasing &error)
: cl_error_catcher(static_cast<cl_error_handler_block>([handler copy]), context, &error)
{
}

/// Handle objective-c block handlers, as they need an explicit copy if they are to be stored.
cl_error_catcher::cl_error_catcher(cl_error_handler_block handler, cl_error_context context, NSError * __strong &error)
: cl_error_catcher(static_cast<cl_error_handler_block>([handler copy]), context, &error)
{
}

// Implicitly convert to pointer to error so that this object can be used in place of &error.
cl_error_catcher::operator NSError * __autoreleasing *()
{
    return m_pError;
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
