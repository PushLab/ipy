//
//  PYKernel.h
//  PYCore
//
//  Created by Push Chen on 7/31/14.
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

#import <Foundation/Foundation.h>

@interface PYKernel : NSObject
{
    NSString                                *_deviceId;
    NSString                                *_version;
    NSString                                *_deviceToken;
    //NSString                                *_carrier;
    NSString                                *_productName;
    NSString                                *_bundleId;
    NSString                                *_oldVersionInCache;
    BOOL                                    _isJailBroken;

    BOOL                                    _isFirstTimeInstall;
}

// Phone Type: iphone
@property (nonatomic, readonly) NSString                *phoneType;
// Device: MD5 of first MAC Address
@property (nonatomic, readonly) NSString                *deviceId;
// Version in Bundle.
@property (nonatomic, readonly) NSString                *version;
// Version in Bundle.
@property (nonatomic, readonly) NSString                *lastVersion;
// Device Token
@property (nonatomic, readonly) NSString                *deviceToken;
// Carrier
//@property (nonatomic, readonly) NSString                *carrier;
// Product name
@property (nonatomic, readonly) NSString                *productName;

// Bundle Id
@property (nonatomic, readonly) NSString                *bundleId;

// Internal Version of this application.
@property (nonatomic, readonly) NSString                *internalVersion;
// Is jail broken
@property (nonatomic, readonly) BOOL                    isJailBroken;

// If current time is first time to install current version.
@property (nonatomic, readonly) BOOL                    isFirstTimeInstall;

// Get shared kernel object.
+ (instancetype)currentKernel;

// Update device token
- (void)updateDeviceToken:(NSString *)newToken;


@end
