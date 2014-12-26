//
//  UIScrollView+PYUIKit.m
//  PYUIKit
//
//  Created by Push Chen on 12/26/14.
//  Copyright (c) 2014 Push Lab. All rights reserved.
//

#import "UIScrollView+PYUIKit.h"
#import "UIView+PYUIKit.h"
#import "PYUIKitMacro.h"

@implementation UIScrollView (PYUIKit)

- (void)setTriggerKeyboardEvent:(BOOL)enable
{
    NSNumber *__keyboardTrigger = [self.layer valueForKey:@"__k__keyboard_trigger"];
    BOOL _enable = NO;
    if ( __keyboardTrigger != nil && [__keyboardTrigger boolValue] ) {
        _enable = YES;
    }
    if ( _enable == enable ) return;
    [self.layer setValue:@(enable) forKey:@"__k__keyboard_trigger"];
    
    if ( enable ) {
        [NF_CENTER addObserver:self
                      selector:@selector(_actionKeyboardChangedHandler:)
                          name:UIKeyboardWillChangeFrameNotification
                        object:nil];
    } else {
        [NF_CENTER removeObserver:self
                             name:UIKeyboardWillChangeFrameNotification
                           object:nil];
    }
}

- (void)_actionKeyboardChangedHandler:(NSNotification *)notify
{
    NSValue *_keyboardToFrame = [notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect _kbEndFrame;
    [_keyboardToFrame getValue:&_kbEndFrame];
    
    NSValue *_lastKeyboardToFrame = [self.layer valueForKey:@"__k__keyboard_lastframe"];
    CGRect _kbLastFrame;
    if ( _lastKeyboardToFrame == NULL ) {
        _kbLastFrame = CGRectZero;
    } else {
        [_lastKeyboardToFrame getValue:&_kbLastFrame];
    }
    
    CGRect _scf = self.frame;
    CGRect _applicationFrame = [UIScreen mainScreen].applicationFrame;
    
    CGFloat _deltaY = _kbLastFrame.origin.y - _kbEndFrame.origin.y;
    CGFloat _deltaHeight = _kbLastFrame.size.height - _kbEndFrame.size.height;
    
    if ( _kbEndFrame.origin.y >= _applicationFrame.size.height ) {
        if ( CGRectEqualToRect(CGRectZero, _kbLastFrame) ) {
            return;
        }
        // Disappear
        [self setFrame:CGRectMake(_scf.origin.x, _scf.origin.y,
                                  _scf.size.width,
                                  _scf.size.height - _deltaY)];
        
        [self scrollRectToVisible:self.bounds animated:YES];
        NSValue *_resetKbFrame = [NSValue valueWithCGRect:CGRectZero];
        [self.layer setValue:_resetKbFrame forKey:@"__k__keyboard_lastframe"];
        return;
    } else if ( _kbEndFrame.origin.y == (_scf.origin.y + _scf.size.height) ) {
        // do nothing
    } else {
        // Show
        [self setFrame:
         CGRectMake(_scf.origin.x, _scf.origin.y,
                    _scf.size.width,
                    _scf.size.height + _deltaHeight)];
    }
    CGSize _displaySize = self.frame.size;
    UIView *_ = [self findFirstResponsder];
    CGRect __f = _.frame;
    __f.origin = [_ originInSuperview:self];
    // Check left space height
    // Make the first responder in the middle
    CGFloat _halfEmptySpace = (_displaySize.height - __f.size.height) / 2;
    if ( __f.origin.y >= _halfEmptySpace &&
        (self.contentSize.height - (__f.origin.y + __f.size.height)) >= _halfEmptySpace ) {
        [self scrollRectToVisible:CGRectMake(0, (__f.origin.y - _halfEmptySpace),
                                             _scf.size.width,
                                             _displaySize.height)
                         animated:YES];
    } else if ( __f.origin.y < _halfEmptySpace ) {
        [self scrollRectToVisible:CGRectMake(0, 0, _scf.size.width, _displaySize.height)
                         animated:YES];
    } else {
        [self scrollRectToVisible:CGRectMake(0, self.contentSize.height - _displaySize.height,
                                             _scf.size.width,
                                             _displaySize.height)
                         animated:YES];
    }
    // Store
    [self.layer setValue:_keyboardToFrame forKey:@"__k__keyboard_lastframe"];
}

@end
