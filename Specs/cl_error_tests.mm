//
//  ClutterTests.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

void maybeSetError(BOOL maybe, NSError **error)
{
    static NSError *s_error;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_error = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:nil];
    });
    if (maybe && error)
        *error = s_error;
}

SPEC_BEGIN(cl_error_tests)

describe(@"ERR_THROW", ^{
    it(@"supports anonymous errors", ^{        
        // anonymous error
        maybeSetError(NO, ERR_THROW()); // should not raise
        [[theBlock(^{ maybeSetError(YES, ERR_THROW()); }) should] raise];
        [[theBlock(^{ maybeSetError(YES, ERR_THROW()); }) should] raise];
    });
    
    it(@"supports NSError*", ^{
            // error on stack
            __block NSError * error;
            maybeSetError(NO, ERR_THROW(error)); // should not raise
            [[theBlock(^{ maybeSetError(YES, ERR_THROW(error)); }) should] raise];
            maybeSetError(YES, ERR_THROW(error)); // should not raise -- same error
    });
    
    it(@"supports NSError** parameters", ^{
            // error as parameter
            NSError * __autoreleasing error;
            NSError * __autoreleasing * pError = &error;
            maybeSetError(NO, ERR_THROW(pError)); // should not raise
            [[theBlock(^{ maybeSetError(YES, ERR_THROW(pError)); }) should] raise];
            maybeSetError(YES, ERR_THROW(pError)); // should not raise -- same error
    });
    
    it(@"supports NULL NSError** parameters", ^{
        // error as parameter, null
        NSError * __autoreleasing * pError = nullptr;
        maybeSetError(NO, ERR_THROW(pError)); // should not raise
        [[theBlock(^{ maybeSetError(YES, ERR_THROW(pError)); }) should] raise];
        [[theBlock(^{ maybeSetError(YES, ERR_THROW(pError)); }) should] raise];
    });
});

SPEC_END
