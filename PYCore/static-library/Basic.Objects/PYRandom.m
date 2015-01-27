//
//  PYRandom.m
//  PYCore
//
//  Created by Push Chen on 11/3/14.
//  Copyright (c) 2014 PushLab. All rights reserved.
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

#import "PYRandom.h"

@implementation PYRandom

+ (void)initialize
{
    // Intialize the random
    srand((unsigned int)time(NULL));
}

+ (NSUInteger)randomIntBetween:(NSUInteger)low to:(NSUInteger)high
{
    double dRlNum;
    dRlNum = ((double)rand())/((double)RAND_MAX + 1);
    return ( (NSUInteger)(dRlNum * (double)(high - low + 1)) + low );
}

+ (double)randomRealBetween:(double)low to:(double)high
{
    double dRlNum;
    dRlNum = ((double)rand()) / ((double)RAND_MAX + 1);
    return (low + dRlNum * (high - low));
}

+ (BOOL)haveAChance:(double)chance
{
    double dRlNum = [PYRandom randomRealBetween:0 to:1];
    return dRlNum <= chance;
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
