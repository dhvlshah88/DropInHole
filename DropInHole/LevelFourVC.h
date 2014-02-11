//
//  LevelFourVC.h
//  DropInHole
//
//  Created by Kalpesh Marlecha on 5/31/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Level4View.h"
#import<AudioToolbox/AudioServices.h>

@interface LevelFourVC : UIViewController <UIAccelerometerDelegate, UINavigationBarDelegate>
{
    IBOutlet UILabel *score;
    IBOutlet UILabel *nextLevel;
}

//Image View for background and ball in level 4.
@property int i;
@property (strong, nonatomic) IBOutlet UIImageView *blueBall;
//Ivars refer to size of ball, size of inner boundary, size of bad hole or pit holes.
@property CGSize ballSize, boundarySize;
//Ivars refer to starting coordinates of ball.
@property CGPoint ballStartingCoord, viewStartCoords;
//Ivars refer to levelOneView
@property (strong, nonatomic) IBOutlet Level4View *level4;
//Ivars refer level id, current and previous score.
@property int currentScore, previousScore;
@property NSString *myLevelName; //Level Name
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *play;

@property(nonatomic) SystemSoundID goal;

-(void) goToMainMenu;

-(void) updateScore;

-(void) vibrate;

@end
