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

#import "CIImage+ClutterAdditions.h"

#import <TargetConditionals.h>
#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)

@implementation CIImage (ClutterAdditions)
- (CIImage *)imageByTranslatingToOrigin
{
    if (self.extent.origin.x || self.extent.origin.y)
        return [self imageByApplyingTransform:CGAffineTransformMakeTranslation(-self.extent.origin.x, -self.extent.origin.y)];
    else
        return self;
}

- (CIImage *)imageByCroppingToSize:(CGSize)size withContentMode:(UIViewContentMode)contentMode
{
    // move image to 0,0
    CIImage *image = [self imageByTranslatingToOrigin];
    
    // prep the image to be cropped from the bottom-left corner
    CGFloat dx = 0;
    CGFloat dy = 0;
    switch (contentMode) {
        case UIViewContentModeBottomRight:
            dx = size.width - image.extent.size.width;
        case UIViewContentModeBottomLeft:
            break;
            
        case UIViewContentModeTopRight:
            dx = size.width - image.extent.size.width;
        case UIViewContentModeTopLeft:
            dy = size.height - image.extent.size.height;
            break;
            
        case UIViewContentModeTop:
            dy = size.height - image.extent.size.height;
        case UIViewContentModeBottom:
            dx = (size.width - image.extent.size.width)/2;
            break;
            
        case UIViewContentModeRight:
            dx = size.width - image.extent.size.width;
        case UIViewContentModeLeft:
            dy = (size.height - image.extent.size.height)/2;
            break;
            
        case UIViewContentModeCenter:
            dx = (size.width - image.extent.size.width)/2;
            dy = (size.height - image.extent.size.height)/2;
            break;
            
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleAspectFill:
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleToFill:
        default:
            // invalid content mode - nothing to do
            break;
    }
    image = [image imageByApplyingTransform:CGAffineTransformMakeTranslation(dx, dy)];
    image = [image imageByCroppingToRect:CGRectMake(0, 0, size.width, size.height)];
    return image;
}

- (CIImage *)imageByResizingToSize:(CGSize)size withContentMode:(UIViewContentMode)contentMode
{
    if (CGSizeEqualToSize(size, self.extent.size)) {
        return self; // well that was easy
    }
    
    // set origin to 0,0
    CIImage *image = [self imageByTranslatingToOrigin];
    
    // rescale the image if necessary, and then crop to the given mode.  rescaled images crop to center.
    CGFloat scaleX = size.width / image.extent.size.width;
    CGFloat scaleY = size.height / image.extent.size.height;
    CGFloat scale;
    switch (contentMode) {
        case UIViewContentModeScaleToFill:
            image = [image imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
            contentMode = UIViewContentModeCenter;
            break;
            
        case UIViewContentModeScaleAspectFit:
            scale = MIN(scaleX, scaleY);
            image = [image imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
            contentMode = UIViewContentModeCenter;
            break;
            
        case UIViewContentModeScaleAspectFill:
            scale = MAX(scaleX, scaleY);
            image = [image imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
            contentMode = UIViewContentModeCenter;
            break;
            
        default:
            break;
    }
    
    return [image imageByCroppingToSize:size withContentMode:contentMode];
}

- (CIImage *)imageByResizingToScale:(CGFloat)scale
{
    if (scale == 1.0)
        return self;
    return [self imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
}
@end
#endif
