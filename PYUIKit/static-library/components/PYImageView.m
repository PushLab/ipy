//
//  PYImageView.m
//  PYUIKit
//
//  Created by Chen Push on 3/8/13.
//  Copyright (c) 2013 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "PYImageView.h"
#import "PYImageCache.h"
#import "PYUIMacro.h"

UIImage * __flipImageForTiledLayerDrawing( UIImage *_in )
{
	if ( PYIsRetina ) {
		UIGraphicsBeginImageContextWithOptions(_in.size, NO, [UIScreen mainScreen].scale);
	} else {
		UIGraphicsBeginImageContext(_in.size);
	}
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	// core rotate fuction
	CGContextTranslateCTM(ctx, 1.f, _in.size.height);
	CGContextScaleCTM(ctx, 1.f, -1.f);
	// draw new picture
	[_in drawInRect:CGRectMake(0, 0, _in.size.width, _in.size.height)];
	UIImage *_ = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return _;
}

CGRect __rectOfAspectFillImage( UIImage *image, CGRect displayRect) {
	float _ds = (displayRect.size.width / displayRect.size.height);
	float _ix = image.size.width * image.scale, _iy = image.size.height * image.scale;
	float _ix_ = _ds * _iy, _iy_ = _ix / _ds;
	CGRect _pushRect = ( _ix_ <= _ix ) ?
    CGRectMake((_ix - _ix_) / 2, 0, _ix_, _iy):
    CGRectMake(0, (_iy - _iy_) / 2, _ix, _iy_);
	return _pushRect;
}

CGRect __rectOfAspectFitImage( UIImage *image, CGRect displayRect ) {
    float _ds = (displayRect.size.width / displayRect.size.height);
    float _ix = image.size.width * image.scale, _iy = image.size.height * image.scale;
    float _is = _ix / _iy;
    if ( _ds > _is ) {
        // Height fixed
        CGFloat _dw = _is * displayRect.size.height;
        return  CGRectMake((displayRect.size.width - _dw) / 2, 0, _dw, displayRect.size.height);
    } else {
        // Width fixed
        CGFloat _dh = (1 / _is) * displayRect.size.width;
        return CGRectMake(0, (displayRect.size.height - _dh) / 2, displayRect.size.width, _dh);
    }
}

@implementation PYAsyncImageLayer
@synthesize imageToDraw;

+ (CFTimeInterval)fadeDuration
{
    return 0.f;
}

- (void)checkAndSetTileSize
{
    if ( PYIsRetina ) {
        self.contentsScale = [UIScreen mainScreen].scale;
    }
//    self.tileSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.height,
//                               [UIScreen mainScreen].applicationFrame.size.height);
}

- (id)init
{
    self = [super init];
    if ( self ) {
        [self checkAndSetTileSize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self checkAndSetTileSize];
    }
    return self;
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if ( self ) {
        [self checkAndSetTileSize];
    }
    return self;
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    self.contentsScale = [UIScreen mainScreen].scale;
}

- (void)drawInContext:(CGContextRef)ctx
{
    if ( self.imageToDraw == nil ) {
        CGContextClearRect(ctx, self.bounds);
        return;
    }
    CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    if ( self.contentMode == UIViewContentModeScaleAspectFit ) {
        CGRect aspectFitRect = __rectOfAspectFitImage(self.imageToDraw, self.bounds);
        CGContextDrawImage(ctx, aspectFitRect, self.imageToDraw.CGImage);
    } else {
        CGRect aspectFillRect = __rectOfAspectFillImage(self.imageToDraw, self.bounds);
        CGImageRef subImageRef = CGImageCreateWithImageInRect(self.imageToDraw.CGImage, aspectFillRect);
        CGContextDrawImage(ctx, self.bounds, subImageRef);
        CFRelease(subImageRef);
    }
    
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0.0, -self.bounds.size.height);
}

@end

/*
 * PYImageView Manager, for global setting
 */
static PYImageViewManager *gImgViewMgr;
@interface PYImageViewManager ()

// Singleton
+ (PYImageViewManager *)sharedManager;

@end

@implementation PYImageViewManager

- (id)init
{
    self = [super init];
    if ( self ) {
        // Default load all images
        _isLoadNetworkImage = YES;
        _loadingQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

// Singleton
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if ( gImgViewMgr == nil ) {
            gImgViewMgr = [super allocWithZone:zone];
        }
    }
    return gImgViewMgr;
}

+ (PYImageViewManager *)sharedManager
{
    @synchronized(self) {
        if ( gImgViewMgr == nil ) {
            gImgViewMgr = [[PYImageViewManager alloc] init];
        }
    }
    return gImgViewMgr;
}

// Peoperties
+ (BOOL)isLoadNetworkImage
{
    @synchronized(self) {
        return [PYImageViewManager sharedManager]->_isLoadNetworkImage;
    }
}

+ (void)setIsLoadNetworkImage:(BOOL)isLoad
{
    @synchronized(self) {
        [PYImageViewManager sharedManager]->_isLoadNetworkImage = isLoad;
    }
}

+ (NSOperationQueue *)imageLoadingQueue
{
    @synchronized(self) {
        return [PYImageViewManager sharedManager]->_loadingQueue;
    }
}

@end

@interface PYImageView ()

- (void)didLoadImage:(UIImage *)netImage forUrl:(NSString *)url;

@end

@implementation PYImageView

@synthesize image = _image, placeholdImage;
@synthesize loadingUrl;
@synthesize delegate;

+ (Class)layerClass
{
    return [PYAsyncImageLayer class];
}

- (void)viewJustBeenCreated
{
    [super viewJustBeenCreated];
    [self setOpaque:NO];    
}

- (void)_startAnimation
{
    if ( _animatorTimer != nil ) return;
    _frameCount = [_image.images count];
    _currentFrame = 0;
    _animatorTimer = [NSTimer scheduledTimerWithTimeInterval:1.f / 7
                                                      target:self
                                                    selector:@selector(_animatorTimerHandler:)
                                                    userInfo:nil repeats:YES];
    [_animatorTimer fire];
    [[NSRunLoop mainRunLoop] addTimer:_animatorTimer forMode:NSRunLoopCommonModes];
}

- (void)_stopAnimation
{
    _frameCount = 0;
    _currentFrame = 0;
    if ( _animatorTimer == nil ) return;
    [_animatorTimer invalidate];
    _animatorTimer = nil;
}

- (void)_animatorTimerHandler:(NSTimer *)timer
{
    [self setNeedsLayout];
    //_currentFrame = (_currentFrame + 1) % _frameCount;
}

- (id)initWithPlaceholdImage:(UIImage *)placehold
{
    self = [super init];
    if ( self ) {
        self.placeholdImage = placehold;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    if ( _image == image ) return;
    [self _stopAnimation];
    
    _image = image;
    [self setNeedsLayout];
    
    if ( _image == nil ) {
        return;
    }
    
    // Check if is Animated GIF
    if ( _image.images != nil && [_image.images count] > 0 ) {
        [self _startAnimation];
    }
}
- (void)setImageUrl:(NSString *)imageUrl
{
    @synchronized(self) {
        
        if ( [imageUrl length] == 0 ) {
            // Clean self's status
            self.loadingUrl = nil;
            self.image = nil;
            [self setNeedsLayout];
            return;
        }
        
        // Check if is loading the image.
        if ( [self.loadingUrl length] > 0 && [self.loadingUrl isEqualToString:imageUrl] ) return;
        
        self.loadingUrl = imageUrl;
        // Fetch the cache.
        self.image = [SHARED_IMAGECACHE imageByName:self.loadingUrl];
        if ( self.image != nil ) {
            [self didLoadImage:self.image forUrl:self.loadingUrl];
            return;
        }
        
        self.image = nil;
        [self setNeedsLayout];
        // Do not load network url
        if ( ![PYImageViewManager isLoadNetworkImage] ) return;

        NSURL *_url = [NSURL URLWithString:self.loadingUrl];
        NSURLRequest *_request = [NSURLRequest requestWithURL:_url];
        [NSURLConnection
         sendAsynchronousRequest:_request
         queue:[PYImageViewManager imageLoadingQueue]
         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
             if ( error != nil ) {
                 // On error
                 NSLog(@"Load image error: %@", [error localizedDescription]);
                 return;
             } else {
                 //NSLog(@"did get image: %@", _url);
             }
             if ( data == nil || [data length] == 0 ) return;   // no image data.
             [SHARED_IMAGECACHE setImage:data forName:imageUrl];
             UIImage *_netImage = [SHARED_IMAGECACHE imageByName:imageUrl];
             if ( _netImage == nil ) return;
             BEGIN_MAINTHREAD_INVOKE
             [self didLoadImage:_netImage forUrl:imageUrl];
             END_MAINTHREAD_INVOKE
         }];
    }
}

#pragma mark
#pragma mark Override
- (void)layoutSubviews
{
    [super layoutSubviews];
    // Redraw self.layer
    PYAsyncImageLayer *_imgLayer = (PYAsyncImageLayer *)self.layer;
    if ( self.image == nil ) {
        _imgLayer.imageToDraw = self.placeholdImage;
    } else {
        if ( _image.images != nil ) {
            _imgLayer.imageToDraw = [_image.images objectAtIndex:_currentFrame];
            _currentFrame = (_currentFrame + 1) % _frameCount;
        } else {
            _imgLayer.imageToDraw = _image;
        }
    }
    [_imgLayer setNeedsDisplay];
}

#pragma mark --
#pragma mark Internal

- (void)didLoadImage:(UIImage *)netImage forUrl:(NSString *)url
{
    // the request is expired
    if ( ![self.loadingUrl isEqualToString:url] ) return;
    
    @synchronized(self) {
        self.image = netImage;
        [self setNeedsLayout];
        
        if ( [self.delegate respondsToSelector:@selector(imageView:didLoadImage:forUrl:)] ) {
            [self.delegate imageView:self didLoadImage:netImage forUrl:url];
        }        
    }
}

@end
