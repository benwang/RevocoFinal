//
//  BMWDetailOverflowController.h
//  Revoco
//
//  Created by Benjamin Wang on 4/30/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMWCoreLocationandMapKit.h"
#import "BMWNote.h"
#import "BMWLocation.h"

@interface BMWDetailOverflowController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    CLLocationCoordinate2D location;
}

@property (strong, nonatomic) BMWNote *detailItem;
@property (weak, nonatomic) IBOutlet MKMapView *detailMap;
@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) NSMutableArray *statuses;
@property (strong, nonatomic) NSString *twitterUser;


- (void) addPinToMapAtCoordinate:(CLLocationCoordinate2D) coordinate;
- (void)parseXMLForUser:(NSString *)user;

@end
