//
//  UIScrollView+PYUIKit.h
//  PYUIKit
//
//  Created by Push Chen on 12/26/14.
//  Copyright (c) 2014 Push Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIScrollViewKeyboardTriggerMode) {
    UIScrollViewKeyboardTriggerContentScale,
    UIScrollViewKeyboardTriggerContentOffset
};

@interface UIScrollView (PYUIKit)

// Keyboard trigger mode, default is UIScrollViewKeyboardTriggerContentScale
@property (nonatomic, assign)   UIScrollViewKeyboardTriggerMode keyboardTriggerMode;

- (void)setTriggerKeyboardEvent:(BOOL)enable;

@end
