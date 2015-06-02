#import "GPUImageFilter.h"

/** Adjusts the saturation of an image
 */
@interface GPUImageSaturationFilter : GPUImageFilter
{
    GLint saturationUniform, vibrancyUniform;
}

/** Saturation ranges from 0.0 (fully desaturated) to 2.0 (max saturation), with 1.0 as the normal level
 */
@property(readwrite, nonatomic) CGFloat saturation; 

/** Saturation ranges from 0.0 (no vibrancy shift) to 1.0 (max vibrancy shift), with 0.0 as the normal level
 */
@property(readwrite, nonatomic) CGFloat vibrancy;


@end
