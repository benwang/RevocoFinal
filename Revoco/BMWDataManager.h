//
//  BMWDataManager.h
//  Revoco
//
//  Created by Benjamin Wang on 3/24/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMWCoreLocationandMapKit.h"
#import "BMWNote.h"
#import "BMWLocation.h"

@class BMWNoteObject;
@interface BMWDataManager : NSObject
    - (BOOL)addNoteContentWithDate:(NSDate *)date Team1:(NSString *)team1 Team2:(NSString *)team2 Detail:(NSString *)details T1Stats:(NSString *)t1stats T2Stats:(NSString *)t2stats Coordinate:(CLLocationCoordinate2D) coordinate;
    - (NSArray *)getAllNotes;
    - (BOOL)deleteNote:(BMWNote *)note;
    - (BOOL)updateNote:(BMWNote *)note Location:(BMWLocation *)location WithDate:(NSDate *)date Team1:(NSString *)team1 Team2:(NSString *)team2 Detail:(NSString *)details T1Stats:(NSString *)t1stats T2Stats:(NSString *)t2stats Coordinate:(CLLocationCoordinate2D) coordinate;
    - (BOOL)deleteAllNotes;

    //may or may not hve time to implement this...
    - (NSArray *)searchNote:(NSString *)text;
@end
