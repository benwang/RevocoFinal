//
//  BMWFindTeamViewController.h
//  Revoco
//
//  Created by Benjamin Wang on 4/27/13.
//  Copyright (c) 2013 Benjamin Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BMWFindTeamViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *nflTeams;
}

//@property(nonatomic, assign) id<UIPickerViewDelegate> delegate;
@property (weak,nonatomic) IBOutlet UIPickerView *pickerView;

- (BOOL)addNFLTeams;

@end