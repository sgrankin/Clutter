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
    
    it(@"supports anonymous NSError* assignments", ^{
        ERR_THROW() = nil; // should not raise
        
        NSError *error;
        maybeSetError(YES, &error);
        [[theBlock(^{ERR_THROW() = error;}) should] raise];
        [[theBlock(^{ERR_THROW() = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:nil];}) should] raise];
    });
    
    it(@"supports slotted NSError* assignments", ^{
        ERR_THROW() = nil;
        
        __block NSError *error1 = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:nil];
        NSError *error2 = error1;
        ERR_THROW(error1) = error2; // should not raise
        [[@((uintptr_t)error1) should] equal:@((uintptr_t)error2)];
        
        [[theBlock(^{ERR_THROW(error1) = [NSError errorWithDomain:NSOSStatusErrorDomain code:1 userInfo:nil];}) should] raise];
        [[@((uintptr_t)error1) shouldNot] equal:@((uintptr_t)error2)];
    });
});

SPEC_END
