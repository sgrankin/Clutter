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

#import "CIImage+CLCoreExt.h"

@implementation CIImage (CLCoreExt)
- (CIImage *)imageByTranslatingToOrigin
{
    if (self.extent.origin.x || self.extent.origin.y)
        return [self imageByApplyingTransform:CGAffineTransformMakeTranslation(-self.extent.origin.x, -self.extent.origin.y)];
    else
        return self;
}

- (CIImage *)imageByCroppingToSize:(CGSize)size withContentMode:(CIImageContentMode)contentMode
{
    // move image to 0,0
    CIImage *image = [self imageByTranslatingToOrigin];

    // prep the image to be cropped from the bottom-left corner
    CGFloat dx = 0;
    CGFloat dy = 0;
    switch (contentMode) {
        case CIImageContentModeBottomRight:
            dx = size.width - image.extent.size.width;
        case CIImageContentModeBottomLeft:
            break;

        case CIImageContentModeTopRight:
            dx = size.width - image.extent.size.width;
        case CIImageContentModeTopLeft:
            dy = size.height - image.extent.size.height;
            break;

        case CIImageContentModeTop:
            dy = size.height - image.extent.size.height;
        case CIImageContentModeBottom:
            dx = (size.width - image.extent.size.width)/2;
            break;

        case CIImageContentModeRight:
            dx = size.width - image.extent.size.width;
        case CIImageContentModeLeft:
            dy = (size.height - image.extent.size.height)/2;
            break;

        case CIImageContentModeCenter:
            dx = (size.width - image.extent.size.width)/2;
            dy = (size.height - image.extent.size.height)/2;
            break;

        case CIImageContentModeScaleAspectFill:
        case CIImageContentModeScaleAspectFit:
        case CIImageContentModeScaleToFill:
        default:
            // invalid content mode - nothing to do
            break;
    }
    image = [image imageByApplyingTransform:CGAffineTransformMakeTranslation(dx, dy)];
    image = [image imageByCroppingToRect:CGRectMake(0, 0, size.width, size.height)];
    return image;
}

- (CIImage *)imageByResizingToSize:(CGSize)size withContentMode:(CIImageContentMode)contentMode
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
        case CIImageContentModeScaleToFill:
            image = [image imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
            contentMode = CIImageContentModeCenter;
            break;

        case CIImageContentModeScaleAspectFit:
            scale = MIN(scaleX, scaleY);
            image = [image imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
            contentMode = CIImageContentModeCenter;
            break;

        case CIImageContentModeScaleAspectFill:
            scale = MAX(scaleX, scaleY);
            image = [image imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
            contentMode = CIImageContentModeCenter;
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
