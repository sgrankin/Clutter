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

#import "UIImage+CLCoreExt.h"

@implementation UIImage (CLCoreExt)

#pragma mark - Resize

- (UIImage *)imageByResizingToSize:(CGSize)size withContentMode:(UIViewContentMode)contentMode
{
    if (CGSizeEqualToSize(self.size, size)) {
        return self; // well that was easy
    }
    
    CGRect frame;
    CGFloat aspectScale = 1.0;
    
    switch (contentMode) {
        case UIViewContentModeScaleToFill:
            frame = CGRectMake(0, 0, size.width, size.height);
            break;
            
        case UIViewContentModeScaleAspectFit:
            aspectScale = MIN(size.width / self.size.width, size.height / self.size.height);
            frame = CGRectMake(size.width/2 - aspectScale*self.size.width/2, size.height/2 - aspectScale*self.size.height/2, aspectScale*self.size.width, aspectScale*self.size.height);
            break;
            
        case UIViewContentModeScaleAspectFill:
            aspectScale = MAX(size.width / self.size.width, size.height / self.size.height);
            frame = CGRectMake(size.width/2 - aspectScale*self.size.width/2, size.height/2 - aspectScale*self.size.height/2, aspectScale*self.size.width, aspectScale*self.size.height);
            break;
            
        case UIViewContentModeCenter: // align contents in center
            frame = CGRectMake(size.width/2 - self.size.width/2, size.height/2 - self.size.height/2, self.size.width, self.size.height);
            break;
            
        case UIViewContentModeTop: // align center horizontal, top of image vertical
            frame = CGRectMake(size.width/2 - self.size.width/2, 0, self.size.width, self.size.height);
            break;
            
        case UIViewContentModeBottom: // align center horizontal, bottom of image vertical
            frame = CGRectMake(size.width/2 - self.size.width/2, size.height - self.size.height, self.size.width, self.size.height);
            break;
            
        case UIViewContentModeLeft:
            frame = CGRectMake(0, size.height/2 - self.size.height/2, self.size.width, self.size.height);
            break;
            
        case UIViewContentModeRight:
            frame = CGRectMake(size.width - self.size.width, size.height/2 - self.size.height/2, self.size.width, self.size.height);
            break;

        case UIViewContentModeTopLeft:
            frame = CGRectMake(0, 0, self.size.width, self.size.height);
            break;

        case UIViewContentModeTopRight:
            frame = CGRectMake(size.width - self.size.width, 0, self.size.width, self.size.height);
            break;

        case UIViewContentModeBottomLeft:
            frame = CGRectMake(0, size.height - self.size.height, self.size.width, self.size.height);
            break;

        case UIViewContentModeBottomRight:
            frame = CGRectMake(size.width - self.size.width, size.height - self.size.height, self.size.width, self.size.height);
            break;
            
        case UIViewContentModeRedraw:
        default:
            frame = CGRectMake(0, 0, size.width, size.height); // not supported, so just do something dumb
            break;
    }
    
    CGFloat scale = self.scale;
    if (scale < [UIScreen mainScreen].scale && aspectScale < 1.0) {
        // we were about to scale the image down while working in a context where we can bump the pixel
        // density.  So, switch the image to screen scale, and proceed with the rendering.
        scale = [UIScreen mainScreen].scale;
    }
    
    // draw and capture an image with an alpha channel
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);    
    [self drawInRect:frame];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}
@end
