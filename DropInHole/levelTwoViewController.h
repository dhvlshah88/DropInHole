//
//  levelTwoViewController.h
//  DropInHole
//
//  Created by vijay mysore on 5/28/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AudioToolbox/AudioServices.h>

@interface levelTwoViewController : UIViewController <UIAccelerometerDelegate,UINavigationBarDelegate>
{
    SystemSoundID ballroll;
    IBOutlet UILabel *time1;
}


// Ivars
@property float x,y;
@property int currentScore,previousScore;
@property (strong,nonatomic) IBOutlet UIImageView *playball;
@property (strong, nonatomic) IBOutlet UINavigationBar *playNavigationBar;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *play;
@property(nonatomic) SystemSoundID ballroll,goal;
@property(strong,nonatomic) NSString *myLevelName;


// methods
- (NSString *) getDBPath;

- (IBAction)back:(id)sender;






@end
