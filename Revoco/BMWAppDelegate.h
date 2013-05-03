//
//  BMWAppDelegate.h
//  Revoco
//
//  Created by Benjamin Wang on 3/13/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMWCoreLocationandMapKit.h"
#import "BMWDataManager.h"

@interface BMWAppDelegate : UIResponder <UIApplicationDelegate>
{
//    BMWCoreLocationandMapKit* sharedManager;
}
//@property (strong, nonatomic) BMWCoreLocationandMapKit *sharedManager;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) BMWDataManager *dataManager;
@property (strong, nonatomic) NSString *team1;
@property (strong, nonatomic) NSString *team2;


@end
