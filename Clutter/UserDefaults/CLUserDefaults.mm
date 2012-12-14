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

#import "CLUserDefaults.h"

#import "MARTNSObject.h"
#import "RTProperty.h"
#import "RTMethod.h"
#import <objc/runtime.h>

@interface CLUserDefaults ()
@property id container;
@end

@implementation CLUserDefaults
+ (instancetype)standardUserDefaults
{
    static dispatch_once_t onceToken;
    static CLUserDefaults *defaults;
    dispatch_once(&onceToken, ^{
        defaults = [[self.class alloc] initWithContainer:[NSUserDefaults standardUserDefaults]];
    });
    return defaults;
}

+ (instancetype)defaultStore
{
    static dispatch_once_t onceToken;
    static CLUserDefaults *defaults;
    dispatch_once(&onceToken, ^{
        defaults = [[self.class alloc] initWithContainer:[NSUbiquitousKeyValueStore defaultStore]];
    });
    return defaults;
}

- (id)init
{
    return [self initWithContainer:[NSUserDefaults standardUserDefaults]];
}

- (id)initWithContainer:(id)container
{
    if (self = [super init]) {
        _container = container;
    }
    return self;
}

- (void)setObject:(id)value forKey:(NSString *)key
{
    [self willChangeValueForKey:key];
    [self.container setObject:value forKey:key];
    [self didChangeValueForKey:key];
}

- (id)objectForKey:(NSString *)key
{
    return [self.container objectForKey:key];
}

+ (id)implForProperty:(RTProperty *)prop setter:(BOOL)setter
{
    NSString *key = prop.name;
    switch ([prop.typeEncoding characterAtIndex:0]) {
        case '@':
            if (setter) return [^(CLUserDefaults *self, id value) { [self setObject:value forKey:key]; } copy];
            else        return [^(CLUserDefaults *self) { return [self objectForKey:key]; } copy];
        
            // Convert primitives to NSNumer values
#define IMPL(T, TYPE, TYPE_UPPER, TYPE_LOWER) \
        case T: \
            if (setter) return [^(CLUserDefaults *self, TYPE value) { [self setObject:[NSNumber numberWith##TYPE_UPPER:value] forKey:key]; } copy]; \
            else        return [^(CLUserDefaults *self) { return [[self objectForKey:key] TYPE_LOWER##Value]; } copy];
            
        IMPL('c', char, Char, char);
        IMPL('d', double, Double, double);
        IMPL('f', float, Float, float);
        IMPL('i', int, Int, int);
        IMPL('l', long, Long, long);
        IMPL('q', long long, LongLong, longLong);
        IMPL('s', short, Short, short);
        IMPL('C', unsigned char, UnsignedChar, unsignedChar);
        IMPL('I', unsigned int, UnsignedInt, unsignedInt);
        IMPL('L', unsigned long, UnsignedLong, unsignedLong);
        IMPL('Q', unsigned long long, UnsignedLongLong, unsignedLongLong);
        IMPL('S', unsigned short, UnsignedShort, unsignedShort);
#undef IMPL
    
    default:
        return NULL;
    }
}

/// Return a signature type for a setter or getter property of given @encoding type
+ (NSString *)methodSignatureForObjCType:(NSString *)type setter:(BOOL)setter
{
    return [NSString stringWithFormat:(setter ? @"v@:%@" : @"%@@:"), type];
}


+ (BOOL)resolveInstanceMethod:(SEL)sel forProperty:(RTProperty *)prop setter:(BOOL)setter
{
    if (id block = [self implForProperty:prop setter:setter]) {
        IMP imp = imp_implementationWithBlock(block);
        NSString *sig = [self methodSignatureForObjCType:prop.typeEncoding setter:setter];
        [self rt_addMethod:[RTMethod methodWithSelector:sel implementation:imp signature:sig]];
        return YES;
    }
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *propName = NSStringFromSelector(sel);

    // assume selector is propName or setPropName:
    BOOL setter = NO;
    if ([propName hasPrefix:@"set"] && [propName hasSuffix:@":"]) {
        propName = [[propName substringToIndex:propName.length-1] stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:[[propName substringWithRange:NSMakeRange(3, 1)] lowercaseString]];
        setter = YES;
    }
    
    // try to resolev the property; only handle dynamic properties.
    RTProperty *prop = [self rt_propertyForName:propName];
    if (prop.isDynamic && [self resolveInstanceMethod:sel forProperty:prop setter:setter])
        return YES;
    return [super resolveInstanceMethod:sel];
}
@end
