//
//  ForKalpesh.h
//  DropInHole-LevelTest
//
//  Created by Kalpesh Marlecha on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewLevel3View.h"
#import<AudioToolbox/AudioServices.h>

@interface ForLevel3ViewController : UIViewController <UIAccelerometerDelegate, UINavigationBarDelegate>

{
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *nextLevelStateLabel;    
}


//Image View for background and ball in level one.
//@property int i;
@property (strong, nonatomic) IBOutlet UIImageView *blueBall;
//Ivars refer to size of ball, size of inner boundary, size of bad hole or pit holes.
@property CGSize ballSize, boundarySize;
//Ivars refer to starting coordinates of ball.
@property CGPoint ballStartingCoord, viewStartCoords;
//Ivars refer to levelOneView
@property (strong, nonatomic) IBOutlet NewLevel3View *level3;
//Ivars refer level id, current and previous score.
@property int currentScore, previousScore;
@property (strong, nonatomic) IBOutlet UINavigationBar *playNavigationBar;

@property (strong, nonatomic) NSString *myLevelName;

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *nextLevelStateLabel;

@property(nonatomic) SystemSoundID goal;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *play;

-(void) vibrate;
- (void) updateScore;

@end
