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

/**
 A dynamic wrapper 
 
 To use, subclass CLUserDefaults and declare @dynamic @properties, of the following types.
 - id (plist only)
 - NSInteger
 - float
 - double
 - BOOL
 
 The generated setters and getters will use the property name as the key.
 */
@interface CLUserDefaults : NSObject

/// An instance initialized with [NSUserDefaults standardUserDefaults]
+ (instancetype)standardUserDefaults;

/// Initialize with the given container.
/// This is the designated initializer.
/// @param container NSUserDefaults or NSUbiquitousKeyValueStore  You may want to call registerDefaults on it.
/// @discussion This is the designated initializer.
- (id)initWithContainer:(NSUserDefaults *)container;

/// Equivalent to initWithContainer:[NSUserDefaults standardDefaults].
- (id)init;

/// The container passed in init.
@property (readonly) NSUserDefaults *container;

@property (weak) id<CLUserDefaultsDelegate> delegate;
@end
