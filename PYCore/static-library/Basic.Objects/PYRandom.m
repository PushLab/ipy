//
//  PYRandom.m
//  PYCore
//
//  Created by Push Chen on 11/3/14.
//  Copyright (c) 2014 PushLab. All rights reserved.
//

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
