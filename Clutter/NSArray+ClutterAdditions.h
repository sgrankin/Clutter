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

#import <Foundation/Foundation.h>

@interface NSArray (ClutterAdditions)

/// First object in the array, or nil if array is empty.
- (id)firstObject;

/// @name Block operations

/// Map an array by applying a given block to each element.
- (NSArray *)mappedArrayUsingBlock:(id (^)(id obj))mapping;

/// Filter an array to those elements for which predicate returns YES.
- (NSArray *)filteredArrayUsingBlock:(BOOL (^)(id obj))predicate;

/// @name Sorting

/// Sorts an array with the elements sorted by the specified keypath and ordering.
/// @param keyPath The property key to use when performing a comparison. In the comparison, the property is accessed using key-value coding.
/// @param ascending YES if the receiver specifies sorting in ascending order, otherwise NO
/// @see [NSSortDescriptor sortDescriptorWithKey:ascending:]
- (NSArray *)sortedArrayWithKey:(NSString *)keyPath ascending:(BOOL)ascending;

/// Sorts an array with the elements sorted by the specified keypath, ordering, and comparator.
/// @param keyPath The property key to use when performing a comparison. In the comparison, the property is accessed using key-value coding.
/// @param ascending YES if the receiver specifies sorting in ascending order, otherwise NO
/// @param comparator A comparator block.  See NSSortDescriptor/+sortDescriptorWithKey:ascending:comparator:
- (NSArray *)sortedArrayWithKey:(NSString *)keyPath ascending:(BOOL)ascending comparator:(NSComparator)comparator;

/// Sorts an array with the elements sorted by the specified keypath, ordering, and comparison selector.
/// @param keyPath The property key to use when performing a comparison. In the comparison, the property is accessed using key-value coding.
/// @param ascending YES if the receiver specifies sorting in ascending order, otherwise NO
/// @param selector The method to use when comparing the properties of objects, for example caseInsensitiveCompare: or localizedCompare:. See NSSortDescriptor/+sortDescriptorWithKey:ascending:selector:
- (NSArray *)sortedArrayWithKey:(NSString *)keyPath ascending:(BOOL)ascending selector:(SEL)selector;
@end
