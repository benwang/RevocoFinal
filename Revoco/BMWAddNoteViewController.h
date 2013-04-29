//
//  BMWAddNoteViewController.h
//  Revoco
//
//  Created by Benjamin Wang on 3/13/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMWNote.h"
#import "BMWAppDelegate.h"
#import "BMWCoreLocationandMapKit.h"
#import "BMWDataManager.h"

@interface BMWAddNoteViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    BMWAppDelegate *appDelegate;
}

@property (nonatomic, strong) BMWCoreLocationandMapKit *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *Team1Label;
@property (weak, nonatomic) IBOutlet UILabel *Team2Label;
@property (weak, nonatomic) IBOutlet UITextView *contentField;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gestureRecognizer;

//Mapnotes stuff...
//@property (weak,nonatomic) IBOutlet UITextField *titleField;
//@property (weak,nonatomic) IBOutlet UITextView *contentField;

- (IBAction)cancelModalViewController:(id)sender;
- (IBAction)doneWithModalViewController:(id)sender;
- (IBAction)viewTapped:(UIGestureRecognizer *)sender;
- (BOOL)textViewShouldEndEditing:(UITextField *)textField;


@end
