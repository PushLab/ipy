//
//  PYHUDView+Singleton.m
//  PYUIKit
//
//  Created by Chen Push on 3/13/13.
//  Copyright (c) 2013 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "PYHUDView+Singleton.h"

static PYHUDView                        *gHudView;

@implementation PYHUDView (Singleton)

// Internal
- (void)_cleanAutoHidingTimer
{
    if ( _autoHidingTimer != nil ) {
        [_autoHidingTimer invalidate];
        _autoHidingTimer = nil;
    }
}

- (void)_startAutoHidingTimer:(CGFloat)duration
{
    _autoHidingTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                        target:self
                                                      selector:@selector(_autoHidingTimerHandler:)
                                                      userInfo:nil
                                                       repeats:NO];
}

- (void)_autoHidingTimerHandler:(NSTimer *)timer
{
    [PYHUDView hideHUDView];
}

- (void)_clearAllData
{
    _title = nil;
    _message = nil;
    _isShowIndicator = NO;
    
    if ( _titleLabel != nil ) {
        _titleLabel.text = @"";
        [_titleLabel removeFromSuperview];
    }
    if ( _messageLabel != nil ) {
        _messageLabel.text = @"";
        [_messageLabel removeFromSuperview];
    }
    if ( _indicatorView != nil ) {
        [_indicatorView removeFromSuperview];
    }
    // Release the customized view
    if ( _customizedView != nil ) {
        [_customizedView removeFromSuperview];
        _customizedView = nil;
    }
    
    [self removeFromSuperview];
}

- (void)_showHUDView
{
    // Kernel Method
    // Create the window
    if ( _containerWindow == nil ) {
        _containerWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _containerWindow.windowLevel = UIWindowLevelAlert;
        _containerWindow.backgroundColor = [UIColor clearColor];
    }
    [_containerWindow setUserInteractionEnabled:!_isEnableUserInactive];
    
    [self setAlpha:0];
    if ( self.superview == nil ) {
        [_containerWindow addSubview:self];
    }
    
    // Resize the frame
    if ( _customizedView != nil ) {
        CGRect _customizeFrame = _customizedView.bounds;
        [self addSubview:_customizedView];
        [self setFrame:[self _calculateHUDFrame:_customizeFrame.size]];
        [_customizedView setCenter:_contentView.center];
    } else {
        CGSize _frameSize = CGSizeZero;
        UIView *_headView = nil;
        if ( _isShowIndicator == YES ) {
            _frameSize = CGSizeMake(36.f, 36.f);
            if ( _indicatorView == nil ) {
                _indicatorView =
                [[UIActivityIndicatorView alloc]
                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            }
            [self addSubview:_indicatorView];
            [_indicatorView startAnimating];
            _headView = _indicatorView;
        }
        if ( [_title length] > 0 ) {
            UIFont *_titleFont = [UIFont boldSystemFontOfSize:14];
            CGSize _titleSize = [_title sizeWithFont:_titleFont];
            if ( _titleSize.width > 160.f )  {
                // max: half of the screen
                _titleSize = [_title sizeWithFont:_titleFont constrainedToSize:CGSizeMake(160.f, 160.f)];
            };
            _frameSize = _titleSize;
            
            // Init the title label
            if ( _titleLabel == nil ) {
                _titleLabel = [[UILabel alloc] init];
                [_titleLabel setFont:_titleFont];
                [_titleLabel setTextColor:[UIColor whiteColor]];
                [_titleLabel setTextAlignment:NSTextAlignmentCenter];
                [_titleLabel setBackgroundColor:[UIColor clearColor]];
                // make the title label support multiple lines
                [_titleLabel setNumberOfLines:50];
            }
            [_titleLabel setText:_title];
            [self addSubview:_titleLabel];
            _headView = _titleLabel;
        }
        CGSize _contentSize = _frameSize;
        CGSize _msgSize = CGSizeZero;
        if ( [_message length] > 0 ) {
            UIFont *_messageFont = [UIFont systemFontOfSize:12];
            _msgSize = [_message sizeWithFont:_messageFont];
            if ( _msgSize.width > 300 ) {
                // no more than 300
                _msgSize = [_message sizeWithFont:_messageFont
                                constrainedToSize:CGSizeMake
                            (300, (_msgSize.width / 300 + 1) * _msgSize.height)];
            }
            _contentSize.width = MAX(_contentSize.width, _msgSize.width);
            if ( _headView != nil )
                _contentSize.height += 20.f;    // padding between head and body
            _contentSize.height += _msgSize.height;
            
            // init the message label
            if ( _messageLabel == nil ) {
                _messageLabel = [[UILabel alloc] init];
                [_messageLabel setFont:_messageFont];
                [_messageLabel setTextColor:[UIColor whiteColor]];
                [_messageLabel setTextAlignment:NSTextAlignmentCenter];
                [_messageLabel setBackgroundColor:[UIColor clearColor]];
                [_messageLabel setNumberOfLines:50];
            }
            [_messageLabel setText:_message];
            [self addSubview:_messageLabel];
        }
        
        CGRect _selfFrame = [self _calculateHUDFrame:_contentSize];
        CGFloat _top = (_selfFrame.size.height - _contentSize.height) / 2;
        if ( _headView != nil ) {
            CGRect _f = CGRectMake((_selfFrame.size.width - _frameSize.width) / 2,
                                   _top, _frameSize.width, _frameSize.height);
            [_headView setFrame:_f];
            _top += (_frameSize.height + 20.f);
        }
        if ( _messageLabel != nil ) {
            CGRect _f = CGRectMake((_selfFrame.size.width - _msgSize.width) / 2,
                                   _top, _msgSize.width, _msgSize.height);
            [_messageLabel setFrame:_f];
        }
        
        // Resize my frame
        [self setFrame:[self _calculateHUDFrame:_contentSize]];
    }
    
    // Display
    [_containerWindow makeKeyAndVisible];
    [UIView animateWithDuration:[PYHUDView displayAnimationDuration] animations:^{
        [self setAlpha:1.f];
    }];
}

- (CGRect)_calculateHUDFrame:(CGSize)contentSize
{
    CGFloat _width = contentSize.width < 120.f ? 120.f : contentSize.width;
    CGFloat _height = (contentSize.height >= _width) ? contentSize.height :
    (
     _width / contentSize.height >= (4 / 3) ? (_width / 4 * 3) : contentSize.height
     );
    CGRect _frame = CGRectInset(CGRectMake(0, 0, _width, _height), -5, -5);
    _frame.origin.x = ([UIScreen mainScreen].applicationFrame.size.width - _frame.size.width) / 2;
    _frame.origin.y = ([UIScreen mainScreen].applicationFrame.size.height - _frame.size.height) / 2;
    return _frame;
}

// Singleton
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if ( gHudView == nil ) {
            gHudView = [super allocWithZone:zone];
        }
    }
    return gHudView;
}

+ (PYHUDView *)sharedHUDView
{
    @synchronized(self) {
        if ( gHudView == nil ) {
            gHudView = [[PYHUDView alloc] init];
        }
    }
    return gHudView;
}

@end
