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
    
    //Twitter feed--Initializing variables
    self.team1Statuses = [[NSMutableArray alloc] init];
    self.team2Statuses = [[NSMutableArray alloc] init];
    self.statusesTemp = [[NSMutableArray alloc] init];
    self.statusesMerged = [[NSMutableArray alloc] init];
    self.currentElementData = [[NSMutableDictionary alloc] init];
    self.currentElementString = [[NSMutableString alloc] init];
    //Initializing Dictionary to convert from TeamName to the team's official TwitterHandle
    [self populateTeamNametoTwitterHandle];
    self.twitterUser1 = [self.teamNametoTwitterHandle objectForKey:self.detailItem.team1];
    NSLog(@"%@",self.twitterUser1);
    self.twitterUser2 = [self.teamNametoTwitterHandle objectForKey:self.detailItem.team2];
    NSLog(@"%@",self.twitterUser2);

    //Parse variables
    //TODO: check if it is array of NSDictoinarys??
    [self parseXMLForUser:self.twitterUser1];
    for (NSMutableDictionary* d in self.statusesTemp) {
        NSLog(@"%@",[d valueForKey:@"text"]);
        [self.team1Statuses addObject:[d valueForKey:@"text"]];
    }
    
    self.statusesTemp = [[NSMutableArray alloc] init];
    
    [self parseXMLForUser:self.twitterUser2];
    for (NSMutableDictionary* d in self.statusesTemp) {
        NSLog(@"%@",[d valueForKey:@"text"]);
        [self.team2Statuses addObject:[d valueForKey:@"text"]];
    }
    
    [self mergeStatuses];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
}

- (void)parseXMLForUser:(NSString *)user {
    
    //Build the Twitter API URL by combining the user with the rest of the URL
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline.xml?screen_name=%@&count=5", user];
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
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"The XML document is now being parsed.");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"Parse error: %d", [parseError code]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    //Store the name of the element currently being parsed.
    self.currentElement = [elementName copy];
    
    //Create an empty mutable string to hold the contents of elements
    self.currentElementString = [NSMutableString stringWithString:@""];
    
    //Empty the dictionary if we're parsing a new status element
    if ([elementName isEqualToString:@"status"]) {
        [self.currentElementData removeAllObjects];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Take the string inside an element (e.g. <tag>string</tag>) and save it in a property
    [self.currentElementString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    //If we've hit the </status> tag, store the data in the statuses array
    if ([elementName isEqualToString:@"status"]) {
        [self.statusesTemp addObject:[self.currentElementData copy]];
    }
    
    //Trim any extra spaces and newline characters from around currentElementString
    NSString *string = [self.currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Store the status data in the currentElementData dictionary
    if ([self.currentElement isEqualToString:@"created_at"]) {
        [self.currentElementData setObject:string forKey:@"created_at"];
    } else if ([self.currentElement isEqualToString:@"text"]) {
        [self.currentElementData setObject:string forKey:@"text"];
    } else if ([self.currentElement isEqualToString:@"retweeted"]) {
        [self.currentElementData setObject:string forKey:@"retweeted"];
    } else if ([self.currentElement isEqualToString:@"id"]) {
        [self.currentElementData setObject:string forKey:@"id"];
    } else if ([self.currentElement isEqualToString:@"profile_image_url"]) {
        [self.currentElementData setObject:string forKey:@"profile_image_url"];
    } else if ([self.currentElement isEqualToString:@"profile_background_image_url"]) {
        [self.currentElementData setObject:string forKey:@"profile_background_image_url"];
    } else if ([self.currentElement isEqualToString:@"profile_link_color"]) {
        [self.currentElementData setObject:string forKey:@"profile_link_color"];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    NSLog(@"%@", self.statusesTemp);
    [self.tableView reloadData];
}

#pragma mark - Prepare for Twitter API call
- (void) mergeStatuses
{
    //Merging team1's updates with team2's updates into one array
    while (self.team1Statuses.count > 0 || self.team2Statuses.count > 0) {
        if (self.team1Statuses.count > 0) {
            [self.statusesMerged addObject:(NSString*)[self.team1Statuses objectAtIndex:0]];
            NSLog(@"1: %@",[self.team1Statuses objectAtIndex:0]);
            [self.team1Statuses removeObjectAtIndex:0];
        }
        if (self.team2Statuses.count > 0) {
            [self.statusesMerged addObject:(NSString*)[self.team2Statuses objectAtIndex:0]];
            NSLog(@"2: %@",[self.team2Statuses objectAtIndex:0]);
            [self.team2Statuses removeObjectAtIndex:0];
        }
    }

}

//I need to move this somewhere else so that I don't reload the dictionary on every view (maybe move to appDelegate to be every time I open app).
//Better yet, I need to figure out how to put this on the backend, so that it's only done once when app first opened
- (void)populateTeamNametoTwitterHandle
{
    self.teamNametoTwitterHandle = [[NSMutableDictionary alloc] init];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"AZCardinals" forKey:@"Arizona Cardinals"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"Atlanta_Falcons" forKey:@"Atlanta Falcons"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"buffalobills" forKey:@"Buffalo Bills"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"Ravens" forKey:@"Baltimore Ravens"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"panthers" forKey:@"Carolina Panthers"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"ChicagoBears" forKey:@"Chicago Bears"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"Bengals" forKey:@"Cincinnati Bengals"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"officialbrowns" forKey:@"Cleveland Browns"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"dallascowboys" forKey:@"Dallas Cowboys"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"denver_broncos" forKey:@"Denver Broncos"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"DetroitLionsNFL" forKey:@"Detroit Lions"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"packers" forKey:@"Green Bay Packers"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"HoustonTexans" forKey:@"Houston Texans"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"nflcolts" forKey:@"Indianapolis Colts"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"jaguars" forKey:@"Jacksonville Jaguars"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"kcchiefs" forKey:@"Kansas City Chiefs"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"MiamiDolphins" forKey:@"Miami Dolphins"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"Vikings" forKey:@"Minnesota Vikings"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"Patriots" forKey:@"New England Patriots"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"Saints" forKey:@"New Orleans Saints"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"Giants" forKey:@"New York Giants"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"nyjets" forKey:@"New York Jets"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"RAIDERS" forKey:@"Oakland Raiders"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"Eagles" forKey:@"Philadelphia Eagles"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"steelers" forKey:@"Pittsburgh Steelers"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"STLouisRams" forKey:@"Saint Louis Rams"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"chargers" forKey:@"San Diego Chargers"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"49ers" forKey:@"San Francisco 49ers"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"Seahawks" forKey:@"Seattle Seahawks"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"TBBuccaneers" forKey:@"Tampa Bay Buccaneers"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"TennesseeTitans" forKey:@"Tennessee Titans"];
    [self.teamNametoTwitterHandle setValue:(NSString*) @"Redskins" forKey:@"Washington Redskins"];
}



#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusesMerged.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *tweet = [self.statusesMerged objectAtIndex:indexPath.row];
    cell.textLabel.text = tweet;
    NSLog(@"%@", tweet);
    
    
    cell.userInteractionEnabled = NO;
    cell.textLabel.font = [UIFont systemFontOfSize:14]; //Change this value to adjust size
    cell.textLabel.numberOfLines = 2;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        BMWNote *object = self.statusesMerged[indexPath.row];
//        self.detailItem = object;
//    }
//}


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
