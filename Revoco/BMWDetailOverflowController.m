//
//  BMWDetailOverflowController.m
//  Revoco
//
//  Created by Benjamin Wang on 4/30/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import "BMWDetailOverflowController.h"

@implementation BMWDetailOverflowController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self configureView];
    
    // Getting object information from _detailItem (and it's attached BMWLocation) from CoreData
    self.detailMap.mapType = MKMapTypeStandard;
    
    location.latitude = self.detailItem.location.lat;
    location.longitude = self.detailItem.location.lon;
    [self addPinToMapAtCoordinate:location];
    
    //Twitter feed
    self.statuses = [[NSMutableArray alloc] init];
    self.twitterUser = [NSString stringWithFormat: @"\{@}%@", self.detailItem.team1];
    
    [self parseXMLForUser:self.twitterUser];
    
//    objects = 
    
}

- (void)parseXMLForUser:(NSString *)user {
    
    //Build the Twitter API URL by combining the user with the rest of the URL
    NSString *urlString = [NSString stringWithFormat:@"http://twitter.com/statuses/user_timeline/%@.xml?count=3", user];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Create an instance of NSXMLParser and download the XML data from the URL
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //Set this class as its own delegate so we can process NSXMLParser callbacks
    [parser setDelegate:self];
    
    //Disable namespace support and other things we don't really need
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse]; //Go go gadget XML parser...
    
    [parser release];
    
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    BMWNote *objectAtCell = [objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [[objectAtCell.team1 stringByAppendingString:@" vs "] stringByAppendingString:[NSString stringWithFormat:@"%@", objectAtCell.team2]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        BMWNote *object = objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}


#pragma mark - MapView Methods

- (void) addPinToMapAtCoordinate:(CLLocationCoordinate2D) coordinate
{
    //this is the red pin
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = coordinate;
    
    //Labels, with latitude/longitude markings to two decimal places
    pin.title = @"Game watched here";
    float lat = coordinate.latitude;
    float lon = coordinate.longitude;
    pin.subtitle = [NSString stringWithFormat: @"lat: ~%f, lon: ~%f", lat, lon];
    
    //Add pin to map, puts center of screen at the pin
    [_detailMap addAnnotation:pin];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    //    CLLocationCoordinate2D newCenter;
    //    newCenter.latitude = location.coordinate.latitude;
    //    newCenter.longitude = location.coordinate.longitude;
    region.span = span;
    region.center = coordinate;//no longer newCenter
    [_detailMap setRegion:region animated:YES];
}

@end
