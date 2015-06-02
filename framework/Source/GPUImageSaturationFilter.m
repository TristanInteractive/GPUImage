#import "GPUImageSaturationFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageSaturationFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform lowp float saturation;
 uniform lowp float vibrancy;
 
 // Values from "Graphics Shaders: Theory and Practice" by Bailey and Cunningham
 const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    lowp float luminance = dot(textureColor.rgb, luminanceWeighting);
    lowp vec3 greyScaleColor = vec3(luminance);
   
    lowp float s = saturation + (distance(textureColor.rgb, greyScaleColor) - 0.5) / 2. * vibrancy;

  	gl_FragColor = vec4(mix(greyScaleColor, textureColor.rgb, s), textureColor.w);
	 
 }
);
#else
NSString *const kGPUImageSaturationFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform float saturation;
 uniform float vibrancy;
 
 // Values from "Graphics Shaders: Theory and Practice" by Bailey and Cunningham
 const vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     float luminance = dot(textureColor.rgb, luminanceWeighting);
     vec3 greyScaleColor = vec3(luminance);
   
     lowp float s = saturation + (distance(textureColor.rgb, greyScaleColor) - 0.5) / 2. * vibrancy;
     
     gl_FragColor = vec4(mix(greyScaleColor, textureColor.rgb, s), textureColor.w);
	 
 }
 );
#endif

@implementation GPUImageSaturationFilter

@synthesize saturation = _saturation;
@synthesize vibrancy = _vibrancy;

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageSaturationFragmentShaderString]))
    {
		return nil;
    }
    
    saturationUniform = [filterProgram uniformIndex:@"saturation"];
    vibrancyUniform = [filterProgram uniformIndex:@"vibrancy"];
    self.saturation = 1.0;
    self.vibrancy = 0.0;

    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setSaturation:(CGFloat)newValue;
{
    _saturation = newValue;
    
    [self setFloat:_saturation forUniform:saturationUniform program:filterProgram];
}

- (void)setVibrancy:(CGFloat)newValue;
{
  _vibrancy = newValue;
  
  [self setFloat:_vibrancy forUniform:vibrancyUniform program:filterProgram];
}

@end

