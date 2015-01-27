//
//  PYMerger.h
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
#import "PYCoreMacro.h"

@interface PYMergerIterator : NSObject

// Current iterator pointed index.
@property (nonatomic, assign)   int         topIndex;
// The list's count
@property (nonatomic, assign)   int         listCount;
// Related list
@property (nonatomic, strong)   NSArray     *list;

// Get current point object in the list.
- (id)topObject;
// Self increase operator, go to the next object.
- (void)goNext;

// Check if topIndex is equal to listCount.
@property (nonatomic, readonly) BOOL        isEnd;

// Iterator creator
+ (PYMergerIterator *)iteratorBegin:(NSArray *)array;
+ (PYMergerIterator *)iteratorEnd:(NSArray *)array;

@end

@interface PYMerger : NSObject

// Merge the lists, use specified comparator, and when enumerate
// each object in the lists, call onEnum.
+ (NSMutableArray *)mergeWithLists:(NSArray *)lists
                           compare:(NSComparator)compare;
+ (NSMutableArray *)mergeWithLists:(NSArray *)lists
                           compare:(NSComparator)compare
                          enumItem:(PYActionGet)onEnum;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
