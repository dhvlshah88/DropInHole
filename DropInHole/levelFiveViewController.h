//
//  levelFiveViewController.h
//  DropInHole
//
//  Created by Dhaval Shah on 04/06/2012.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "levelFiveView.h"
#import "powerForL5View.h"
#import "Level.h"
#import "AppDelegate.h"
#import "optionsViewController.h"

@interface levelFiveViewController : UIViewController <UIAccelerometerDelegate,UIGestureRecognizerDelegate>

//IBoutlet for level five view.
@property (strong, nonatomic) IBOutlet levelFiveView *levelFive;
//IBOutlet for power view.
@property (strong, nonatomic) IBOutlet powerForL5View *powerView;
//IBOutlet for blue ball image view.
@property (strong, nonatomic) IBOutlet UIImageView *blueBall;
//IBOutlet for progress bar for time.
@property (strong, nonatomic) IBOutlet UIProgressView *levelCountDown;

//Ivars refers level id, current and previous score.
@property int levelId, currentScore, previousScore, bonusScore;

//Ivars refers to size of ball, size of inner boundary, size of bad hole or pit holes.
@property CGSize ballSize, boundarySize;

//Ivars refers to starting coordinates of ball.
@property CGPoint ballStartingCoord, viewStartCoords;

//Ivars refers to total time in seconds given to user to complete the level and seconds lapsed will playing.
@property double totalSeconds, secondLeft;

//Ivars refers to system sound object.
@property(nonatomic) SystemSoundID ballInHoleSound;

-(void) activatePowerOfType:(int) powertype;

-(void) startCountDown;

-(void) updateScoreForLevel:(int)score;

-(void) ballInDestHole;

-(void) loadSoundFile;

@end
