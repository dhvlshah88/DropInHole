//
//  mainScreenViewController.h
//  DropInHole
//
//  Created by Dhaval Shah on 5/14/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainScreenViewController : UIViewController
{
    int position;
}
// IBOutlet for levels button
@property (nonatomic, strong) IBOutlet UIButton *playButton;
// IBOutlet for options button
@property (nonatomic, strong) IBOutlet UIButton *optionButton;
// IBOutlet for about us button
@property (nonatomic, strong) IBOutlet UIButton *aboutUsButton;
// IBOutlet for main menu background image view
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImage;
// IBOutlet for blue ball image view
@property (nonatomic, strong) IBOutlet UIImageView *ball;
// IBOutlet for gray ball image view
@property (nonatomic, strong) IBOutlet UIImageView *ballGrey;
// IBOutlet for red ball image view
@property (nonatomic, strong) IBOutlet UIImageView *ballRed;  

-(IBAction)goToOption;
-(IBAction)goToAboutUs;
-(IBAction)goToLevelStack;
-(void) moveToNextView:(UIViewController *) viewControllerToCall withId:(NSString *) uniqueId;

@end