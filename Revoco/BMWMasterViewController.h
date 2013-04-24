//
//  BMWMasterViewController.h
//  Revoco
//
//  Created by Benjamin Wang on 4/23/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMWDetailViewController;

#import <CoreData/CoreData.h>

@interface BMWMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) BMWDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
