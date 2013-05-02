//
//  BMWDetailViewController.h
//  Revoco
//
//  Created by Benjamin Wang on 3/13/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BMWNote.h"
#import "BMWLocation.h"

@interface BMWDetailViewController : UIViewController <UISplitViewControllerDelegate>
{
    CLLocationCoordinate2D location;
}

@property (strong, nonatomic) BMWNote *detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UITextView *detailContent;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
//@property (strong, nonatomic) IBOutlet MKMapView *detailMap;

//- (void) addPinToMapAtCoordinate:(CLLocationCoordinate2D) coordinate;


@end
