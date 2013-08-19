//
//  PYViewController.h
//  UIKitDemo
//
//  Created by Push Chen on 7/27/13.
//  Copyright (c) 2013 Push Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PYTableViewDatasource, PYTableViewDelegate>
{
    UITableView                         *_tableView;
    
    UIImageView                         *_imageView;
    
    PYTableView                         *_pyTableView;
    
    NSTimer                             *_slideTimer;
}

@end
