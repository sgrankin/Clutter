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

#import "UIApplication+CLCoreExt.h"

#import <objc/runtime.h>

// Helper for UIApplication/-addObserver.  Should be owned by the delegate.
@interface CLUIApplicationDelegateObserver : NSObject
@property (weak) id<UIApplicationDelegate> delegate;

- (id)initWithDelegate:(id<UIApplicationDelegate>)delegate;
- (void)handleNotification:(NSNotification *)note;

@end

@implementation UIApplication (CLCoreExt)

#pragma mark - UIApplicationDelegate observer
static char const *CLUIApplicationDelegateObserver_Key = "UIApplicationDelegateNotifier";

/// Add an observer object that will be notified of all UIApplication notifications that it supports.
- (void)addObserver:(id<UIApplicationDelegate>)delegate
{
    if (!objc_getAssociatedObject(delegate, CLUIApplicationDelegateObserver_Key)) {
        CLUIApplicationDelegateObserver *observer = [[CLUIApplicationDelegateObserver alloc] initWithDelegate:delegate];
        objc_setAssociatedObject(delegate, CLUIApplicationDelegateObserver_Key, observer, OBJC_ASSOCIATION_RETAIN);
    }
}

/// Remove an observer object added via addObserver.
- (void)removeObserver:(id<UIApplicationDelegate>)delegate
{
    objc_setAssociatedObject(delegate, CLUIApplicationDelegateObserver_Key, nil, OBJC_ASSOCIATION_RETAIN);
}
@end


@implementation CLUIApplicationDelegateObserver
- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer" userInfo:nil];
}

- (id)initWithDelegate:(id<UIApplicationDelegate>)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        
#define OBSERVE(Notification, Selector) if ([delegate respondsToSelector:@selector(Selector)]) { \
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:Notification object:UIApplication.sharedApplication]; }
        
        OBSERVE(UIApplicationDidEnterBackgroundNotification, applicationDidEnterBackground:);
        OBSERVE(UIApplicationDidEnterBackgroundNotification, applicationDidEnterBackground:);
        OBSERVE(UIApplicationWillEnterForegroundNotification, applicationWillEnterForeground:);
        
        // NOTE: we can use the withOptions: call hree as well if we grab the options from userInfo
        OBSERVE(UIApplicationDidFinishLaunchingNotification, applicationDidFinishLaunching:);
        OBSERVE(UIApplicationDidBecomeActiveNotification, applicationDidBecomeActive:);
        OBSERVE(UIApplicationWillResignActiveNotification, applicationWillResignActive:);
        OBSERVE(UIApplicationDidReceiveMemoryWarningNotification, applicationDidReceiveMemoryWarning:);
        OBSERVE(UIApplicationWillTerminateNotification, applicationWillTerminate:);
        OBSERVE(UIApplicationSignificantTimeChangeNotification, applicationSignificantTimeChange:);
        OBSERVE(UIApplicationWillChangeStatusBarOrientationNotification, application:willChangeStatusBarOrientation:duration:);
        OBSERVE(UIApplicationDidChangeStatusBarOrientationNotification, application:didChangeStatusBarOrientation:);
        OBSERVE(UIApplicationWillChangeStatusBarFrameNotification, application:willChangeStatusBarFrame:);
        OBSERVE(UIApplicationDidChangeStatusBarFrameNotification, application:didChangeStatusBarFrame:);
#undef OBSERVE
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleNotification:(NSNotification *)note
{
    UIApplication *application = note.object;
    
    UIInterfaceOrientation statusBarOrientation = (UIInterfaceOrientation)[note.userInfo[UIApplicationStatusBarOrientationUserInfoKey] intValue];
    CGRect statusBarFrame = [note.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    
    id<UIApplicationDelegate> delegate = self.delegate;
    if (self.delegate) {
#define OBSERVE(Notification, SelectorCall) if ([note.name isEqualToString:Notification]) { [delegate SelectorCall]; }
        
        OBSERVE(UIApplicationDidEnterBackgroundNotification, applicationDidEnterBackground:application);
        OBSERVE(UIApplicationDidEnterBackgroundNotification, applicationDidEnterBackground:application);
        OBSERVE(UIApplicationWillEnterForegroundNotification, applicationWillEnterForeground:application);
        
        // NOTE: we can use the withOptions: call hree as well if we grab the options from userInfo
        OBSERVE(UIApplicationDidFinishLaunchingNotification, applicationDidFinishLaunching:application);
        OBSERVE(UIApplicationDidBecomeActiveNotification, applicationDidBecomeActive:application);
        OBSERVE(UIApplicationWillResignActiveNotification, applicationWillResignActive:application);
        OBSERVE(UIApplicationDidReceiveMemoryWarningNotification, applicationDidReceiveMemoryWarning:application);
        OBSERVE(UIApplicationWillTerminateNotification, applicationWillTerminate:application);
        OBSERVE(UIApplicationSignificantTimeChangeNotification, applicationSignificantTimeChange:application);
        OBSERVE(UIApplicationWillChangeStatusBarOrientationNotification, application:application willChangeStatusBarOrientation:statusBarOrientation duration:application.statusBarOrientationAnimationDuration);
        OBSERVE(UIApplicationDidChangeStatusBarOrientationNotification, application:application didChangeStatusBarOrientation:statusBarOrientation);
        OBSERVE(UIApplicationWillChangeStatusBarFrameNotification, application:application willChangeStatusBarFrame:statusBarFrame);
        OBSERVE(UIApplicationDidChangeStatusBarFrameNotification, application:application didChangeStatusBarFrame:statusBarFrame);
#undef OBSERVE
    }
}
@end
