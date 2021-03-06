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

#import "NSArray+CLCoreExt.h"

@implementation NSArray (CLCoreExt)

- (id)firstObject
{
    return self.count > 0 ? self[0] : nil;
}

#pragma mark - Transforms with blocks

- (NSArray *)mappedArrayUsingBlock:(id (^)(id obj))mapping
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:mapping(obj)];
    }];
    return result;
}

- (NSArray *)filteredArrayUsingBlock:(BOOL (^)(id obj))predicate
{
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return predicate(evaluatedObject);
    }]];
}

- (id)reduceWithInitialValue:(id)initial block:(id (^)(id, id))block
{
    id val = initial;
    for (id obj in self)
        val = block(val, obj);
    return val;
}

#pragma mark - Ordering

- (NSArray *)sortedArrayWithKey:(NSString *)keyPath ascending:(BOOL)ascending
{
    return [self sortedArrayUsingDescriptors:@[[NSSortDescriptor
                                                sortDescriptorWithKey:keyPath
                                                ascending:ascending]]];
}

- (NSArray *)sortedArrayWithKey:(NSString *)keyPath
                      ascending:(BOOL)ascending
                     comparator:(NSComparator)comparator
{
    return [self sortedArrayUsingDescriptors:@[[NSSortDescriptor
                                                sortDescriptorWithKey:keyPath
                                                ascending:ascending
                                                comparator:comparator]]];
}

- (NSArray *)sortedArrayWithKey:(NSString *)keyPath
                      ascending:(BOOL)ascending
                       selector:(SEL)selector
{
    return [self sortedArrayUsingDescriptors:@[[NSSortDescriptor
                                                sortDescriptorWithKey:keyPath
                                                ascending:ascending
                                                selector:selector]]];
}

- (NSArray *)reversedArray
{
    return [[self reverseObjectEnumerator] allObjects];
}



@end
