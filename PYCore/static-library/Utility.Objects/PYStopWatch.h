//
//  PYStopWatch.h
//  PYCore
//
//  Created by Push Chen on 6/10/13.
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
#include <sys/time.h>
#include <sys/timeb.h>
#include <libkern/OSAtomic.h>

@interface PYStopWatch : NSObject
{
	struct timeval _startTime, _endTime;
    struct timeval _pausedTime;
	double _timePassed;
    double _timePaused;
    
    OSSpinLock _handle;
    BOOL _paused;
}

// Get the global watch instance
+ (PYStopWatch *)globalWatch;

// Last tick second.
@property (nonatomic, readonly)	double	seconds;
// Last tick millesecond.
@property (nonatomic, readonly) double	milleseconds;

// Initialize the start time, and start to calculate the time passed.
- (void)start;
// Pause the timer
- (void)pause;
// Resume the stop watch to calculate the time passed.
- (void)resume;
// Get current tick time.
- (double)tick;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
