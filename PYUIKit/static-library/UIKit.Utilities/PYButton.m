//
//  PYButton.m
//  PYUIKit
//
//  Created by Push Chen on 10/10/14.
//  Copyright (c) 2014 Push Lab. All rights reserved.
//

#import "PYButton.h"

@interface PYButton ()
{
    UIColor *_cachedBackgroundColor[5];
}
@end

@implementation PYButton

- (void)initializeTargetBind
{
    [self addTarget:self action:@selector(actionOnTouchDown:)
   forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(actionOnTouchUp:)
   forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(actionOnTouchUp:)
   forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(actionOnTouchUp:)
   forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(actionOnTouchUp:)
   forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(actionOnTouchUp:)
   forControlEvents:UIControlEventTouchCancel];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self initializeTargetBind];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if ( self ) {
        [self initializeTargetBind];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self initializeTargetBind];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    // Override
    [super setBackgroundColor:backgroundColor];
    _cachedBackgroundColor[UIControlStateNormal] = backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    _cachedBackgroundColor[state] = backgroundColor;
    if ( state == self.state ) {
        [super setBackgroundColor:backgroundColor];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if ( selected ) {
        if ( _cachedBackgroundColor[UIControlStateSelected] != nil ) {
            [super setBackgroundColor:_cachedBackgroundColor[UIControlStateSelected]];
        }
    } else {
        if ( _cachedBackgroundColor[UIControlStateNormal] != nil ) {
            [super setBackgroundColor:_cachedBackgroundColor[UIControlStateNormal]];
        }
    }
}
- (void)actionOnTouchDown:(id)sender
{
    if ( _cachedBackgroundColor[UIControlStateHighlighted] != nil ) {
        [super setBackgroundColor:_cachedBackgroundColor[UIControlStateHighlighted]];
    }
}

- (void)actionOnTouchUp:(id)sender
{
    if ( _cachedBackgroundColor[UIControlStateNormal] != nil ) {
        [super setBackgroundColor:_cachedBackgroundColor[UIControlStateNormal]];
    }
}

@end
