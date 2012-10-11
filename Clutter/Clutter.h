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

#ifndef Clutter_Clutter_h
#define Clutter_Clutter_h

#import "ClutterMacros.h"

#include "cl_error.h"

#if defined(__cplusplus)
// c-only code needs an extern "C" declaration so that c++ calls will match.
extern "C" {
#endif

#ifdef __OBJC__
#import "CIImage+ClutterAdditions.h"
#import "NSArray+ClutterAdditions.h"
#import "NSFetchedResultsController+ClutterAdditions.h"
#import "NSMutableDictionary+ClutterAdditions.h"
#import "NSObject+ClutterAdditions.h"
#import "NSString+ClutterAdditions.h"
#import "NSURL+ClutterAdditions.h"
#import "NSURLRequest+ClutterAdditions.h"
#import "UIApplication+ClutterAdditions.h"
#import "UIImage+ClutterAdditions.h"
#import "UISearchBar+ClutterAdditions.h"
#import "UISegmentedControl+ClutterAdditions.h"
#import "UITableViewCell+ClutterAdditions.h"

#import "CLElasticSlider.h"
#import "CLStateMachine.h"
    
#endif // __OBJC__

#if defined(__cplusplus)
}
#endif

#endif // Clutter_Clutter_h
