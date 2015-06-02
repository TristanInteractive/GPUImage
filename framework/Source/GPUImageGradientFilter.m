#import "GPUImageGradientFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageLinearGradientFragmentShaderString = SHADER_STRING
(
 uniform sampler2D inputImageTexture;
 varying highp vec2 textureCoordinate;
 
 uniform lowp vec3 gradientStartColor;
 uniform lowp vec3 gradientEndColor;
 uniform highp float gradientAlpha;
 
 void main()
 {
     lowp vec4 sourceImageColor = texture2D(inputImageTexture, textureCoordinate);
     lowp float percent = textureCoordinate.y;
     gl_FragColor = vec4(mix(mix(sourceImageColor.rgb, gradientStartColor, (1.0-percent)*gradientAlpha),
                                 gradientEndColor, percent*gradientAlpha),
                         sourceImageColor.a);
 }
);
#else
NSString *const kGPUImageLinearGradientFragmentShaderString = SHADER_STRING
(
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform vec3 gradientStartColor;
 uniform vec3 gradientEndColor;
 uniform float gradientAlpha;
 
 void main()
 {
   
     vec4 sourceImageColor = texture2D(inputImageTexture, textureCoordinate);
     float percent = textureCoordinate.y;
     gl_FragColor = vec4(mix(mix(sourceImageColor.rgb, gradientStartColor, (1.0-percent)*gradientAlpha),
                             gradientEndColor, percent*gradientAlpha),
                         sourceImageColor.a);
 }
);
#endif

@implementation GPUImageGradientFilter

@synthesize startColor = _startColor;
@synthesize endColor = _endColor;
@synthesize alpha = _alpha;

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageLinearGradientFragmentShaderString]))
    {
		return nil;
    }
    
    gradientColorStartUniform = [filterProgram uniformIndex:@"gradientStartColor"];
    gradientColorEndUniform = [filterProgram uniformIndex:@"gradientEndColor"];
    gradientAlphaUniform = [filterProgram uniformIndex:@"gradientAlpha"];
  
    self.startColor = (GPUVector3){ 0.0f, 0.0f, 0.0f };
    self.endColor = (GPUVector3){ 0.0f, 0.0f, 0.0f };
    self.alpha = 1.0;
  
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setStartColor:(GPUVector3)newValue
{
    _startColor = newValue;
    
    [self setVec3:newValue forUniform:gradientColorStartUniform program:filterProgram];
}

- (void)setEndColor:(GPUVector3)newValue
{
  _endColor = newValue;
  
  [self setVec3:newValue forUniform:gradientColorEndUniform program:filterProgram];
}

- (void)setAlpha:(float)newValue
{
  _alpha = newValue;
  
  [self setFloat:newValue forUniform:gradientAlphaUniform program:filterProgram];
}

@end
