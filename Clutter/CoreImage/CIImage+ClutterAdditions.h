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

#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
#import <CoreImage/CoreImage.h>
#else
#import <QuartzCore/QuartzCore.h>
#endif

typedef NS_ENUM(NSInteger, CIImageContentMode)
{
    CIImageContentModeScaleToFill,
    CIImageContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    CIImageContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    CIImageContentModeCenter = 4,          // contents remain same size. positioned adjusted.
    CIImageContentModeTop,
    CIImageContentModeBottom,
    CIImageContentModeLeft,
    CIImageContentModeRight,
    CIImageContentModeTopLeft,
    CIImageContentModeTopRight,
    CIImageContentModeBottomLeft,
    CIImageContentModeBottomRight,
};

@interface CIImage (ClutterAdditions)

/// Translate image such that image.exent.origin == {0,0}
- (CIImage *)imageByTranslatingToOrigin;

/// Crop the image.
/// @param size The size of the image to crop to.
/// @param contentsGravity The edge/corner of the image to crop from.  Any contentsGravity that desn't mention at least
////    one edge will result in cropping to bottom-left.  Defaults to kCAGravityCenter
- (CIImage *)imageByCroppingToSize:(CGSize)size withContentMode:(CIImageContentMode)contentMode;

/// Resize the image by scaling and cropping.
/// @param size The size of the final image.
/// @param contentsGravity For scaling modes, scale the image and crop to size on center.  For cropping modes,
///     crop to corner/edge..  Defaults to kCAGravityCenter
- (CIImage *)imageByResizingToSize:(CGSize)size withContentMode:(CIImageContentMode)contentMode;

/// Resize the image by scaling both dimensions by scale.
/// @param scale Scale to apply to both dimensions of the image.
- (CIImage *)imageByResizingToScale:(CGFloat)scale;
@end
