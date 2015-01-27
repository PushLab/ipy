//
//  PYEncoder.h
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
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <zlib.h>

@interface PYEncoder : NSObject

// Base64 Coder of data
+ (NSString *)encodeBase64FromData:(const char *)input length:(unsigned long)length;
+ (NSData *)decodeBase64ToData:(NSString *)input;

// String Coder for base64
+ (NSString *)encodeBase64:(NSString *)input;
+ (NSString *)decodeBase64:(NSString *)input;

// MD5 Sum
+ (NSString *)md5sum:(NSString *)input;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
