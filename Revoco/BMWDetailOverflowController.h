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

@interface BMWDetailOverflowController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
{
    CLLocationCoordinate2D location;
}

@property (strong, nonatomic) BMWNote *detailItem;
@property (weak, nonatomic) IBOutlet MKMapView *detailMap;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) NSMutableArray *statusesTemp;
@property (strong, nonatomic) NSMutableArray *team1Statuses;
@property (strong, nonatomic) NSMutableArray *team2Statuses;
@property (strong, nonatomic) NSMutableArray *statusesMerged;
@property (strong, nonatomic) NSString *twitterUser1;
@property (strong, nonatomic) NSString *twitterUser2;
@property (nonatomic, retain) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *currentElementData;
@property (nonatomic, retain) NSMutableString *currentElementString;

@property (strong, nonatomic) NSMutableDictionary *teamNametoTwitterHandle;


- (void) addPinToMapAtCoordinate:(CLLocationCoordinate2D) coordinate;
- (void)parseXMLForUser:(NSString *)user;
- (void)populateTeamNametoTwitterHandle;
- (void) mergeStatuses;

@end
