//
//  BMWCoreLocationandMapKit.m
//  Revoco
//
//  Created by Benjamin Wang on 3/13/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import "BMWCoreLocationandMapKit.h"

@implementation BMWCoreLocationandMapKit

#pragma mark - Singleton Methods

// access by declaring: BMWCoreLocationandMapKit *sharedManager = [BMWCoreLocationandMapKit sharedManager];
+ (id)sharedManager {
    static BMWCoreLocationandMapKit *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Location Manager and MapView Methods

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:
(NSArray *) locations
{
    //maybe add neat feature later
}

- (id) init {
    if (self = [super init]) {
        self.mapView = [[MKMapView alloc] init];
        self.locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (void) stopUpdating
{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void) resumeUpdating
{
    [self.locationManager startMonitoringSignificantLocationChanges];
}

//Moved this to BMWDetailViewController
//- (void) addPinToMapAtLocation:(CLLocation *) location
//{
//    //this is the red pin
//    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
//    pin.coordinate = location.coordinate;
//
//    //Labels, with latitude/longitude markings to two decimal places
//    pin.title = @"Note created here";
//    float lat = location.coordinate.latitude;
//    float lon = location.coordinate.longitude;
//    pin.subtitle = [NSString stringWithFormat: @"lat: ~%f, lon: ~%f", lat, lon];
//
//    //Add pin to map, puts center of screen at the pin
//    [_mapView addAnnotation:pin];
//    MKCoordinateRegion region;
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.01;
//    span.longitudeDelta = 0.01;
//    CLLocationCoordinate2D newCenter;
//    newCenter.latitude = location.coordinate.latitude;
//    newCenter.longitude = location.coordinate.longitude;
//    region.span = span;
//    region.center = newCenter;
//    [_mapView setRegion:region animated:YES];
//}

@end
