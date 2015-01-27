//
//  PYSemaphore.h
//  PYCore
//
//  Created by Push Chen on 6/12/13.
//  Copyright (c) 2013 PushLab. All rights reserved.
//

/*
 LGPL V3 Lisence
 This file is part of cleandns.
 
 PYCore is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 PYData is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with cleandns.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 LISENCE FOR IPY
 COPYRIGHT (c) 2013, Push Chen.
 ALL RIGHTS RESERVED.
 
 REDISTRIBUTION AND USE IN SOURCE AND BINARY
 FORMS, WITH OR WITHOUT MODIFICATION, ARE
 PERMITTED PROVIDED THAT THE FOLLOWING CONDITIONS
 ARE MET:
 
 YOU USE IT, AND YOU JUST USE IT!.
 WHY NOT USE THIS LIBRARY IN YOUR CODE TO MAKE
 THE DEVELOPMENT HAPPIER!
 ENJOY YOUR LIFE AND BE FAR AWAY FROM BUGS.
 */

#import <Foundation/Foundation.h>
#import "PYCoreMacro.h"
#import "PYMutex.h"

typedef pthread_cond_t  PYSemHandleT;

enum { SEM_MAXCOUNT = 0x0FFFF, SEM_MAXTIMEOUT = 0xFFFFFFFF };

@interface PYSemaphore : NSObject
{
    PYSemHandleT                    _sem;
    int32_t                         _max;
    volatile int32_t                _current;
    volatile bool                   _available;
    
    // Mutex to lock the m_Current.
    PYMutex                         *_mutex;
    pthread_condattr_t              _condAttr;
}

// Signal count
@property (nonatomic, readonly) NSUInteger              count;
@property (nonatomic, readonly) BOOL                    isAvailable;
@property (nonatomic, readonly) int32_t                 maxCount;

- (id)initWithCount:(int)initCount;
- (id)initWithCount:(int)initCount maxCount:(int32_t)max;

// Get the semaphore with specified timeout
- (BOOL)get;
- (BOOL)getUntil:(NSUInteger)timedout;
- (BOOL)tryGet;

// Release a semaphore
- (BOOL)give;

// Destroy the semaphore
- (void)destroy;

// Clear all signal.
- (void)clear;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
