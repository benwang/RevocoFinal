//
//  BMWMasterViewController.h
//  Revoco
//
//  Created by Benjamin Wang on 3/13/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMWAppDelegate.h"
#import "BMWNote.h"

@class BMWDetailViewController;

@interface BMWMasterViewController : UITableViewController < UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) BMWDetailViewController *detailViewController;
@property (strong, nonatomic) BMWDataManager *dataManager;

@end
