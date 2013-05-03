//
//  BMWAddNoteViewController.m
//  Revoco
//
//  Created by Benjamin Wang on 3/13/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import "BMWAddNoteViewController.h"
#import "BMWFindTeamViewController.h"
#define kBMWESPNAPIToken @"jpdb9wzbdd4ezqgr5asc3d3x"

@interface BMWAddNoteViewController ()
{
    CLLocationCoordinate2D location;
    
}
    @property (weak,nonatomic) NSDate *date;
@end

@implementation BMWAddNoteViewController

#pragma mark - Default View Controller Methods

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
    
    //Implement Done button    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(returnText)];
    self.navigationItem.rightBarButtonItem = doneButton;

    
    appDelegate = (BMWAppDelegate *)[[UIApplication sharedApplication] delegate];
    /*
//Mapnotes designation
//    self.titleField.delegate = self;
     */
    self.contentField.delegate = self;
    
	// Set up background image
    UIImage *patternImage = [UIImage imageNamed:@"fabric_of_squares_gray.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    //Setting up AlertView for missing teams
    //Alert view initializations
    self.missingTeamAlertView = [[UIAlertView alloc] initWithTitle:@"Select a Valid Team" message:@"You did not select a valid team" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    self.missingTeamAlertView.delegate = self;//I call "show" in doneWithModalviewController method

    
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

#pragma mark - Navigation methods

- (IBAction)cancelModalViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (IBAction)doneWithModalViewController:(id)sender
- (void) returnText
{
    if (appDelegate.team1 == nil || [appDelegate.team1 isEqual: @"Team1"] || appDelegate.team2 == nil || [appDelegate.team2 isEqual: @"Team2"])
    {
        [self.missingTeamAlertView show];
    } else
    {
        BMWDataManager *dataManager = [(BMWAppDelegate*)[[UIApplication sharedApplication] delegate] dataManager];
        
        //getting and setting date and location
        self.date = [NSDate date];
        BMWCoreLocationandMapKit *sharedManager = [BMWCoreLocationandMapKit sharedManager];
        location.latitude = sharedManager.locationManager.location.coordinate.latitude;
        location.longitude = sharedManager.locationManager.location.coordinate.longitude;
        
        //Getting stats from http://www.pro-football-reference.com/
        //sets self.team1Stats and self.team2Stats to add to CoreData
        [self parseNFLCSV];        
        
        //Put data into back end
        BOOL status = [dataManager addNoteContentWithDate:self.date Team1:self.Team1Label.text Team2:self.Team2Label.text Detail:self.contentField.text T1Stats:self.team1Stats T2Stats:self.team2Stats Coordinate:location];
        NSLog(status ? @"Yes" : @"No");
        
        //Reset team1/team2 vars to set label for next time you add a note
        appDelegate.team1 = @"Team1";
        appDelegate.team2 = @"Team2";
        
        [self.navigationController popViewControllerAnimated:YES];
        //    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Interaction with Stats API
- (void) parseNFLCSV
{    
    //Read all text from file
    NSString* filePath = @"nfl2012";
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:filePath ofType:@"csv"];
    
    NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot encoding:NSUTF8StringEncoding error:NULL];
//    NSString *absoluteURL = @"n"
//    NSURL *url = [NSURL URLWithString:absoluteURL];
//    NSString *fileContents = [[NSString alloc] initWithContentsOfURL:url];
    NSLog(@"%@",fileContents);
    
    //Separate by newline
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    NSLog(@"%@",[allLinedStrings objectAtIndex:0]);
    
    NSString* team1Score;
    NSString* team1Yards;
    NSString* team1Turnovers;
    NSString* team2Score;
    NSString* team2Yards;
    NSString* team2Turnovers;
    
    //Manually go through each line and collect relevant stats if team is mentioned; this will run through the file and find the stats for the most recent game played
    for (int i = 0; i < allLinedStrings.count && [[allLinedStrings objectAtIndex:i] length] != 0; i++)
    {
        NSArray *list = [[allLinedStrings objectAtIndex:i] componentsSeparatedByString:@","];
        if ([[list objectAtIndex:4] isEqualToString:appDelegate.team1])
        {
            team1Score = [list objectAtIndex:7];
            team1Yards = [list objectAtIndex:9];
            team1Turnovers = [list objectAtIndex:10];
        } else if ([[list objectAtIndex:6] isEqualToString:appDelegate.team1])
        {
            team1Score = [list objectAtIndex:8];
            team1Yards = [list objectAtIndex:11];
            team1Turnovers = [list objectAtIndex:12];
        }
        if ([[list objectAtIndex:4] isEqualToString:appDelegate.team2])
        {
            team2Score = [list objectAtIndex:7];
            team2Yards = [list objectAtIndex:9];
            team2Turnovers = [list objectAtIndex:10];
        } else if ([[list objectAtIndex:6] isEqualToString:appDelegate.team2])
        {
            team2Score = [list objectAtIndex:8];
            team2Yards = [list objectAtIndex:11];
            team2Turnovers = [list objectAtIndex:12];
        } 
    }
    
    //Prepare return values
    NSString *stats1 = [NSString stringWithFormat:@"Score: %@\rYards: %@\rTurnovers: %@", team1Score, team1Yards, team1Turnovers];
    NSString *stats2 = [NSString stringWithFormat:@"Score: %@\rYards: %@\rTurnovers: %@", team2Score, team2Yards, team2Turnovers];
    
    self.team1Stats = stats1;
    self.team2Stats = stats2;
}

#pragma mark - Gesture Recognizer Methods

- (IBAction)viewTapped:(UIGestureRecognizer *)sender
{
    [self textViewShouldEndEditing:(UITextView*)self.contentField];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

# pragma mark - Segue transitions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"getTeam"]) {
        // Message Pass to BMWFindTeamViewController that you should be setting Team1Label
        [[segue destinationViewController] setSegueID:@"Team1"];
        }
    else if ([[segue identifier] isEqualToString:@"getTeam2"]) {
        [[segue destinationViewController] setSegueID:@"Team2"];
    }
}

# pragma mark - AlertView for Missing Team

- (void) showAlert {
    [self.missingTeamAlertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Clicked OK");
    } else {
        NSLog(@"Wow.  Rude.");
    }
}

@end
