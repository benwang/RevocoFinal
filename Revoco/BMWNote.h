//
//  BMWNote.h
//  Revoco
//
//  Created by Benjamin Wang on 3/28/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BMWLocation;

@interface BMWNote : NSManagedObject

@property (nonatomic, retain) NSString * team1;
@property (nonatomic, retain) NSString * team2;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString * detailString;
@property (nonatomic, retain) NSMutableArray * images;
@property (nonatomic, retain) NSString * team1Stats;
@property (nonatomic, retain) NSString * team2Stats;
@property (nonatomic, retain) NSMutableArray * twitterFeed;
@property (nonatomic, retain) BMWLocation *location;

@end
