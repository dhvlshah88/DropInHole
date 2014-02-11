//
//  levelsViewController.h
//  DropInHole
//
//  Created by Dhaval Shah on 5/15/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "levelOneViewController.h"
#import "levelTwoViewController.h"
#import "ForLevel3ViewController.h"
#import "LevelFourVC.h"
#import "levelFiveViewController.h"
#import "LevelBuilderViewController.h"
#import "Level.h"

@interface levelsViewController : UITableViewController

//IBOutlet for Main Menu button.
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

-(IBAction)goBackToMainMenu;

@end