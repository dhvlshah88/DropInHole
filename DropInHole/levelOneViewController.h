//
//  levelOneViewController.h
// 
//
//  Created by Dhaval Shah on 5/11/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "levelOneView.h"
#import "optionsViewController.h"
#import "AppDelegate.h"
#import "Level.h"

@interface levelOneViewController : UIViewController <UIAccelerometerDelegate, UIGestureRecognizerDelegate>

//IBOutlet's for background and ball image in level one.
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage, *blueBall;

//Ivars refers to size of ball, size of inner boundary, size of bad hole or pit holes.
@property CGSize ballSize, boundarySize, badHoleSize;

//Ivars refers to starting coordinates of ball.
@property CGPoint ballStartingCoord;

//IBOutlet refers to levelOneView
@property (strong, nonatomic) IBOutlet levelOneView *levelOne;

//Ivars refers to array contacting bad holes details. 
@property (strong, nonatomic) NSMutableArray *badHoles;

//Ivars refers level id, current and previous score.
@property int levelId, currentScore, previousScore, bonusScore;

//Ivars refers to total time in seconds given to user to complete the level and seconds lapsed will playing.
@property int totalSeconds, secondLapsed;

//Ivars refers to system sound object.
@property(nonatomic) SystemSoundID ballInHoleSound;

-(void) loadNavigationBar;
-(void) checkBallInBadHoleAreaOfSection: (int) sectionNo;
-(void) ballInBadHole;
-(void) ballInDestHole;
-(void) circularCountDown;
-(void) updateScoreForLevel:(int) score;
-(void) loadSoundFile;

@end
