//
//  options View Controller.h
//  firstview
//
//  Created by Dhaval Shah on 5/11/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioServices.h>
#include <AudioToolbox/AudioToolbox.h>
#import "highScoresViewController.h"

@interface optionsViewController : UITableViewController

// IBOutlet used for bar button item on navigation bar.
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

// IBOutlet used for vibration switch.
@property (strong, nonatomic) IBOutlet UISwitch *vibrationSwitch;

// IBOutlet used for sound switch.
@property (strong, nonatomic) IBOutlet UISwitch *soundSwitch;

//IBOutlet used for high scores cell.
@property (strong, nonatomic) IBOutlet UITableViewCell *highscores;

// IBOutlet used for textfield to store username. 
@property (strong, nonatomic) IBOutlet UITextField *userNameField;

// This ivars is used to store system sound object
@property (nonatomic) SystemSoundID ballInHoleSound;

-(IBAction)goBackToMainMenu;
-(IBAction)dismissKeyboard:(id) sender;
-(void)vibrate;
-(IBAction)vibrateOnOff;	
-(IBAction)soundOnOff;
-(void) playSound;
-(void) addUserName:(NSString *) username;

@end
