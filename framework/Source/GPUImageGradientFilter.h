#import "GPUImageFilter.h"

/** Overlays a linear gradient between two colours (top to bottom)
 *   --- could be extended to accept a vector, start/end compression points, an array of colours/points, etc.
 */
@interface GPUImageGradientFilter : GPUImageFilter
{
    GLint gradientColorStartUniform, gradientColorEndUniform, gradientAlphaUniform;
}

// The color to use for the top of the gradient (defaults to black)
@property (nonatomic, readwrite) GPUVector3 startColor;

// The color to use for the bottom of the gradient (defaults to black)
@property (nonatomic, readwrite) GPUVector3 endColor;

// The alpha to apply with the gradient
@property (nonatomic, readwrite) float alpha;

@end
