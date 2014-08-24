//
//  PYTableManager.h
//  PYUIKit
//
//  Created by Push Chen on 8/20/14.
//  Copyright (c) 2014 Push Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYTableManagerProtocol.h"
#import "PYTableView.h"

@interface PYTableManager : PYActionDispatcher
    <PYTableManagerProtocol, PYTableViewDelegate, PYTableViewDatasource>
{
    PYTableView                 *_bindTableView;
    NSArray                     *_contentDataSource;
    Class                       _defaultCellClass;
    
    // Stop at item if the table support page.
    id                          __unsafe_unretained _willStopItem;
    id                          __unsafe_unretained _didStopItem;
}

// The cell class
- (Class)classOfCellAtIndex:(NSIndexPath *)index;

// Set the cell class
@property (nonatomic, assign)   Class           defaultCellClass;

// The datasource.
@property (nonatomic, readonly) NSArray         *contentDataSource;

// Stop item
@property (nonatomic, readonly) id __unsafe_unretained  willStopItem;
@property (nonatomic, readonly) id __unsafe_unretained  didStopItem;

@end
