//
//  BMWAddNoteViewController.m
//  Revoco
//
//  Created by Benjamin Wang on 3/13/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import "BMWAddNoteViewController.h"

@interface BMWAddNoteViewController ()
{
    CLLocationCoordinate2D location;
    
}
    @property (weak,nonatomic) NSDate *date;
@end

@implementation BMWAddNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    appDelegate = (BMWAppDelegate *)[[UIApplication sharedApplication] delegate];
    /*
//Mapnotes designation
//    self.titleField.delegate = self;
     */
    self.contentField.delegate = self;
    
	// Set up background image
    UIImage *patternImage = [UIImage imageNamed:@"fabric_of_squares_gray.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    //Prep for exiting keyboard out of title field when you return
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (appDelegate.team1) {
        self.Team1Label.text = appDelegate.team1;
    }
    if (appDelegate.team2) {
        self.Team2Label.text = appDelegate.team2;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelModalViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneWithModalViewController:(id)sender
{
    //first save the data
    BMWDataManager *dataManager = [(BMWAppDelegate*)[[UIApplication sharedApplication] delegate] dataManager];
    //    BMWNote *object = [NSEntityDescription insertNewObjectForEntityForName:kBMWEntityName inManagedObjectContext:context];
    //    object.titleString = titleField.text;
    //    object.detailString = contentField.text;
    //    object.date = [NSDate date];
    self.date = [NSDate date];
    BMWCoreLocationandMapKit *sharedManager = [BMWCoreLocationandMapKit sharedManager];
    location.latitude = sharedManager.locationManager.location.coordinate.latitude;
    location.longitude = sharedManager.locationManager.location.coordinate.longitude;
    
    //no need for objects array anymore
//    [appDelegate.objects addObject:object];
    
    //then put it into core data
/*MapNotes designation
//    NSLog(@"%@", self.titleField.text);
*/
    NSLog(@"%@",self.Team1Label.text);
    NSLog(@"%@",self.Team2Label.text);
    NSLog(@"%@", self.contentField.text);
    
    //TODO:::: to fix dataManager for new update
//    BOOL status = [dataManager addNoteContentWithDate:self.date Title:self.titleField.text Detail:self.contentField.text Coordinate:location];
//    NSLog(status ? @"Yes" : @"No");
//    [appDelegate.objects addObject:]
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)viewTapped:(UIGestureRecognizer *)sender
{
    [self textViewShouldEndEditing:self.contentField];
}

- (BOOL)textViewShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
