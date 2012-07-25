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

#import "NSObject+ClutterAdditions.h"

#import <objc/runtime.h>

/// Helper for KVO observation.  Will be retained by the observed object.
@interface CLNSObjectObserver : NSObject
@property NSMutableDictionary *blocks; // keyPath -> [block]

- (void)addObserverOfObject:(id)object forKeyPath:(NSString *)keyPath block:(void(^)(id self))block;
- (void)removeObserverOfObject:(id)object forKeyPath:(NSString *)keyPath;
@end


@implementation NSObject (ClutterAdditions)

#pragma mark - Block-based KVO
- (CLNSObjectObserver *)cl_kvoObjectObserver
{
    static char const *CLNSObjectObserver_Key = "CLNSObjectObserver";
    CLNSObjectObserver *observer = objc_getAssociatedObject(self, CLNSObjectObserver_Key);
    if (!observer) {
        observer = [CLNSObjectObserver new];
        objc_setAssociatedObject(self, CLNSObjectObserver_Key, observer, OBJC_ASSOCIATION_RETAIN);
    }
    return observer;
}

- (void)addObserverForKeyPath:(NSString *)keyPath withBlock:(void(^)(id self))block
{
    [[self cl_kvoObjectObserver] addObserverOfObject:self forKeyPath:keyPath block:block];
}

- (void)removeObserversForKeyPath:(NSString *)keyPath
{
    [[self cl_kvoObjectObserver] removeObserverOfObject:self forKeyPath:keyPath];
}
@end


@implementation CLNSObjectObserver
- (id)init
{
    if (self = [super init]) {
        self.blocks = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addObserverOfObject:(id)object forKeyPath:(NSString *)keyPath block:(void(^)(id self))block
{
    @synchronized (self.blocks) {
        if (!self.blocks[keyPath])
            self.blocks[keyPath] = [NSMutableArray array];
        [self.blocks[keyPath] addObject:block];
        [object addObserver:self forKeyPath:keyPath options:0 context:(__bridge void *)(block)];
    }
}

- (void)removeObserverOfObject:(id)object forKeyPath:(NSString *)keyPath
{
    @synchronized (self.blocks) {
        [self.blocks removeObjectForKey:keyPath];
        [object removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    void(^block)(id) = (__bridge void(^)(id))context;
    block(object);
}
@end
