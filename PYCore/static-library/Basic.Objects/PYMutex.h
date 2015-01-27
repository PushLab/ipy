//
//  PYMutex.h
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

#ifndef _PYCORE_PYMUTEX_HEADER_H_
#define _PYCORE_PYMUTEX_HEADER_H_

#import <Foundation/Foundation.h>
#include <pthread.h>

typedef id (^PYMutexAction)();

typedef pthread_mutex_t     PYMutexHandleT;

@interface PYMutex : NSObject
{
    @public
    PYMutexHandleT              _mutex;
    BOOL                        _enableDebug;
}

@property (nonatomic, assign)   BOOL            enableDebug;
// Mutex Actions
- (void)lock;
- (id)lockAndDo:(PYMutexAction)action;
- (void)unlock;
- (BOOL)tryLock;

@end

#endif

// @littlepush
// littlepush@gmail.com
// PYLab
