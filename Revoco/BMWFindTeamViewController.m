//
//  BMWFindTeamViewController.m
//  Revoco
//
//  Created by Benjamin Wang on 4/27/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import "BMWFindTeamViewController.h"

@implementation BMWFindTeamViewController

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
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.appDelegate = (BMWAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.navigationController.navigationBarHidden = NO;
    
    //Implement Done button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(returnText)];
    self.navigationItem.rightBarButtonItem = doneButton;
     
    
	// Set up background image
    UIImage *patternImage = [UIImage imageNamed:@"NFL_logo.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    //Initialize PickerView array
    nflTeams = [[NSMutableArray alloc] init];
    [self addNFLTeams];
}

#pragma mark - Manipulating Team Array

- (void) returnText
{
    [self.navigationController popViewControllerAnimated:YES];
//dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)addNFLTeams
{
    [nflTeams addObject:@"Atlanta Falcons"];
    [nflTeams addObject:@"Arizona Cardinals"];
    [nflTeams addObject:@"Atlanta Falcons"];
    [nflTeams addObject:@"Baltimore Ravens"];
    [nflTeams addObject:@"Buffalo Bills"];
    [nflTeams addObject:@"Carolina Panthers"];
    [nflTeams addObject:@"Chicago Bears"];
    [nflTeams addObject:@"Cincinnati Bengals"];
    [nflTeams addObject:@"Cleveland Browns"];
    [nflTeams addObject:@"Dallas Cowboys"];
    [nflTeams addObject:@"Denver Broncos"];
    [nflTeams addObject:@"Detroit Lions"];
    [nflTeams addObject:@"Green Bay Packers"];
    [nflTeams addObject:@"Houston Texans"];
    [nflTeams addObject:@"Indianapolis Colts"];
    [nflTeams addObject:@"Jacksonville Jaguars"];
    [nflTeams addObject:@"Kansas City Chiefs"];
    [nflTeams addObject:@"Miami Dolphins"];
    [nflTeams addObject:@"Minnesota Vikings"];
    [nflTeams addObject:@"New England Patriots"];
    [nflTeams addObject:@"New Orleans Saints"];
    [nflTeams addObject:@"New York Giants"];
    [nflTeams addObject:@"New York Jets"];
    [nflTeams addObject:@"Oakland Raiders"];
    [nflTeams addObject:@"Philadelphia Eagles"];
    [nflTeams addObject:@"Pittsburgh Steelers"];
    [nflTeams addObject:@"Saint Louis Rams"];
    [nflTeams addObject:@"San Diego Chargers"];
    [nflTeams addObject:@"San Francisco 49ers"];
    [nflTeams addObject:@"Seattle Seahawks"];
    [nflTeams addObject:@"Tampa Bay Buccaneers"];
    [nflTeams addObject:@"Tennessee Titans"];
    [nflTeams addObject:@"Washington Redskins"];
    return YES;
}

#pragma mark - Required UIPickerView Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{    
    return [nflTeams count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [nflTeams objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{    
    NSLog(@"Selected Team: %@. Index of selected team: %i", [nflTeams objectAtIndex:row], row);
    if  ([self.segueID isEqualToString: @"Team1"]) {
        self.appDelegate.team1 = [nflTeams objectAtIndex:row];
    }
    else if ([self.segueID isEqualToString:@"Team2"]) {
        self.appDelegate.team2 = [nflTeams objectAtIndex:row];
    }
}

@end






