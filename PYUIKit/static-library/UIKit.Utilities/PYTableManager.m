//
//  PYTableManager.m
//  PYUIKit
//
//  Created by Push Chen on 8/20/14.
//  Copyright (c) 2014 Push Lab. All rights reserved.
//

#import "PYTableManager.h"
#import "PYTableViewCell.h"
#import "PYTableCell.h"

@implementation PYTableManager

@synthesize contentDataSource = _contentDataSource;
@synthesize defaultCellClass = _defaultCellClass;

@synthesize willStopItem = _willStopItem;
@synthesize didStopItem = _didStopItem;


+ (void)initialize
{
    // Register default event
    [PYTableManager registerEvent(PYTableManagerEventCreateNewCell)];
    [PYTableManager registerEvent(PYTableManagerEventTryToGetHeight)];
    [PYTableManager registerEvent(PYTableManagerEventWillDisplayCell)];
    [PYTableManager registerEvent(PYTableManagerEventSelectCell)];
    [PYTableManager registerEvent(PYTableManagerEventUnSelectCell)];
    [PYTableManager registerEvent(PYTableManagerEventWillScroll)];
    [PYTableManager registerEvent(PYTableManagerEventUserActivityToScroll)];
    [PYTableManager registerEvent(PYTableManagerEventScroll)];
    [PYTableManager registerEvent(PYTableManagerEventWillEndScroll)];
    [PYTableManager registerEvent(PYTableManagerEventEndScroll)];
    [PYTableManager registerEvent(PYTableManagerEventDeleteCell)];
    [PYTableManager registerEvent(PYTableManagerEventGetCellClass)];
}

- (id)init
{
    self = [super init];
    if ( self ) {
        _defaultCellClass = [PYTableViewCell class];
    }
    return self;
}

- (void)reloadTableData
{
    @synchronized( self ) {
        if ( _bindTableView == nil ) return;
        // Clear
        PYASSERT(_contentDataSource != nil, @"Content data source for scroll view cannot be null");
        PYASSERT(([_contentDataSource isKindOfClass:[NSArray class]]),
                 @"Hey! Why you give me an identify which does not point to an array object?");
        [_bindTableView reloadData];
        NSArray *_visiableCells = _bindTableView.visiableCells;
        PYTableViewCell *_firstCell = [_visiableCells safeObjectAtIndex:0];
        if ( _firstCell == nil ) return;
        _willStopItem = [_contentDataSource safeObjectAtIndex:_firstCell.cellIndex];
        _didStopItem = _willStopItem;
    }
}

- (void)bindTableView:(id)tableView
{
    [self bindTableView:tableView withDataSource:nil];
}

// Bind the table view, reload data with specified datasource.
- (void)bindTableView:(PYTableView *)tableView withDataSource:(NSArray *)dataSource
{
    @synchronized( self ) {
        // Clear old table's info.
        if ( _bindTableView != nil ) {
            [_bindTableView removeTarget:self
                                  action:@selector(actionTouchBeginForTableView:event:)
                       forResponderEvent:PYResponderEventTouchBegin];
            _bindTableView.delegate = nil;
            _bindTableView.dataSource = nil;
            _bindTableView = nil;
        }
        
        // Bind new table
        _bindTableView = tableView;
        _bindTableView.delegate = self;
        _bindTableView.dataSource = self;
        [_bindTableView addTarget:self
                           action:@selector(actionTouchBeginForTableView:event:)
                forResponderEvent:PYResponderEventTouchBegin];
        
        if ( dataSource == nil ) {
            // We load en empty data source.
            _contentDataSource = [NSArray array];
        } else {
            // Copy the data source.
            _contentDataSource = [NSArray arrayWithArray:dataSource];
        }
        
        // Reload data.
        [self reloadTableData];
    }
}

- (void)reloadTableDataWithDataSource:(NSArray *)dataSource
{
    @synchronized( self ) {
        if ( _bindTableView == nil ) return;
        if ( dataSource == nil ) {
            // We load en empty data source.
            _contentDataSource = [NSArray array];
        } else {
            // Copy the data source.
            _contentDataSource = [NSArray arrayWithArray:dataSource];
        }
        
        // Reload data.
        [self reloadTableData];
    }
}

// Get item at specified index
- (id)dataItemAtIndex:(NSUInteger)index
{
    if ( _contentDataSource == nil ) return nil;
    return [_contentDataSource safeObjectAtIndex:index];
}

- (id)dataItemAtIndex:(NSUInteger)index section:(NSUInteger)section
{
    // Ignore section
    return [self dataItemAtIndex:index];
}
- (id)dataItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Ignore section
    return [self dataItemAtIndex:indexPath.row];
}

- (Class)classOfCellAtIndex:(NSIndexPath *)index
{
    Class _cell_class = [self invokeTargetWithEvent:PYTableManagerEventGetCellClass exInfo:index];
    if ( _cell_class != NULL ) return _cell_class;
    return _defaultCellClass;
}

#pragma mark --
#pragma mark TableView

- (void)actionTouchBeginForTableView:(PYTableView *)tableView event:(PYResponderEvent *)event
{
    // The user is going to scroll the table view.
    [self invokeTargetWithEvent:PYTableManagerEventUserActivityToScroll];
}

- (NSInteger)pytableViewNumberOfRows:(PYTableView *)tableView
{
    if ( _contentDataSource == nil ) return 0;
    return [_contentDataSource count];
}

- (CGFloat)pytableView:(PYTableView *)tableView heightForRowAtIndex:(NSInteger)index
{
    id _item = [_contentDataSource safeObjectAtIndex:index];
    if ( _item == nil ) return 0;
    NSNumber *_result = [self
                         invokeTargetWithEvent:PYTableManagerEventTryToGetHeight
                         exInfo:[NSIndexPath indexPathForRow:index inSection:0]];
    if ( _result == nil ) {
        //_result =
        if ( [_defaultCellClass respondsToSelector:@selector(heightOfCellWithSpecifiedContentItem:)] ) {
            _result = [_defaultCellClass heightOfCellWithSpecifiedContentItem:_item];
        }
    }
    if ( _result == nil ) return 0.f;
    return [_result floatValue];
}

- (PYTableViewCell *)pytableView:(PYTableView *)tableView cellForRowAtIndex:(NSInteger)index
{
    // Create the cell.
    NSString *_cellIdentify = NSStringFromClass(_defaultCellClass);
    PYTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentify];
    if ( _cell == nil ) {
        Class _ccls = [self classOfCellAtIndex:[NSIndexPath indexPathForRow:index inSection:0]];
        _cell = [[_ccls alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:_cellIdentify];
        [self invokeTargetWithEvent:PYTableManagerEventCreateNewCell exInfo:_cell];
    }
    return _cell;
}

- (void)pytableView:(PYTableView *)tableView
    willDisplayCell:(PYTableViewCell *)cell
            atIndex:(NSInteger)index
{
    id _item = [_contentDataSource safeObjectAtIndex:index];
    [cell tryPerformSelector:@selector(rendCellWithSpecifiedContentItem:) withObject:_item];
    [self invokeTargetWithEvent:PYTableManagerEventWillDisplayCell
                         exInfo:cell
                         exInfo:[NSIndexPath indexPathForRow:index inSection:0]];
    [cell setNeedsLayout];
}

- (void)pytableView:(PYTableView *)tableView didSelectCellAtIndex:(NSInteger)index
{
    // Nothing... not support tap.
    if ( _contentDataSource == nil ) return;
    id _cell = [tableView cellForRowAtIndex:index];
    if ( _cell == nil ) return;
    [self invokeTargetWithEvent:PYTableManagerEventSelectCell
                         exInfo:_cell
                         exInfo:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)pytableView:(PYTableView *)tableView unSelectCellAtIndex:(NSInteger)index
{
    // Nothing... not support tap.
    if ( _contentDataSource == nil ) return;
    id _cell = [tableView cellForRowAtIndex:index];
    if ( _cell == nil ) return;
    [self invokeTargetWithEvent:PYTableManagerEventUnSelectCell
                         exInfo:_cell
                         exInfo:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)pyScrollViewDidScroll:(PYScrollView *)scrollView
{
    [self invokeTargetWithEvent:PYTableManagerEventScroll exInfo:scrollView];
}

- (void)pyScrollViewDidEndScroll:(PYScrollView *)scrollView willDecelerate:(BOOL)decelerated
{
    // Did end scroll...
    if ( decelerated == YES ) {
        if ( _bindTableView.isPagable ) {
            NSUInteger _cellCount = [_contentDataSource count];
            if ( _cellCount == 0 ) return;
            int _stopIndex = -1;
            
            float _contentSideSize = ((_bindTableView.scrollSide == PYScrollHorizontal) ?
                                      scrollView.contentSize.width :
                                      scrollView.contentSize.height);
            float _offsetSize = ((_bindTableView.scrollSide == PYScrollHorizontal) ?
                                 scrollView.contentOffset.width :
                                 scrollView.contentOffset.height);
            float _willStopSize = ((_bindTableView.scrollSide == PYScrollHorizontal) ?
                                   scrollView.willStopOffset.width :
                                   scrollView.willStopOffset.height);
            float _offset = ((_contentSideSize -
                              _willStopSize +
                              _offsetSize) + 1);
            while ( _offset < 0 ) _offset += _contentSideSize;
            float _cellSize = [self pytableView:_bindTableView heightForRowAtIndex:0];
            int _counts = (int)(_offset / _cellSize);
            _stopIndex = _counts % _cellCount;
            _willStopItem = [_contentDataSource safeObjectAtIndex:_stopIndex];
        }
        [self invokeTargetWithEvent:PYTableManagerEventWillEndScroll exInfo:scrollView];
    } else {
        [self pyScrollViewDidEndDecelerate:scrollView];
    }
}

- (void)pyScrollViewDidEndDecelerate:(PYScrollView *)scrollView
{
    if ( _bindTableView.isPagable ) {
        NSUInteger _cellCount = [_contentDataSource count];
        if ( _cellCount == 0 ) return;
        int _stopIndex = -1;
        
        float _contentSideSize = ((_bindTableView.scrollSide == PYScrollHorizontal) ?
                                  scrollView.contentSize.width :
                                  scrollView.contentSize.height);
        float _offsetSize = ((_bindTableView.scrollSide == PYScrollHorizontal) ?
                             scrollView.contentOffset.width :
                             scrollView.contentOffset.height);
        float _offset = _offsetSize + 1.f;
        while ( _offset < 0 ) _offset += _contentSideSize;
        float _cellSize = [self pytableView:_bindTableView heightForRowAtIndex:0];
        int _counts = (int)(_offset / _cellSize);
        _stopIndex = _counts % _cellCount;
        _didStopItem = [_contentDataSource safeObjectAtIndex:_stopIndex];
    }
    
    [self invokeTargetWithEvent:PYTableManagerEventEndScroll exInfo:scrollView];
}

@end
