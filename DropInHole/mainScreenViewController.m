//
//  mainScreenViewController.m
//  DropInHole
//
//  Created by Dhaval Shah on 5/14/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mainScreenViewController.h"
#import "levelOneViewController.h"
#import "optionsViewController.h"
#import "aboutUsViewController.h"
#import "levelsViewController.h"

@implementation mainScreenViewController{
    NSTimer *timer;
}

@synthesize playButton, optionButton, aboutUsButton, ball, ballGrey, ballRed;
@synthesize backgroundImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    self.ball.frame = CGRectMake(26, 119, 27, 27);
    self.ballGrey.frame = CGRectMake(56, 279, 27, 27);   
    self.ballRed.frame = CGRectMake(86, 179, 27, 27);
}

//Here the three balls are animated. 
- (void)startAnimation
{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        if(position == 1){
            self.ball.frame = CGRectMake(26, 309, 20, 20);
            self.ballGrey.frame = CGRectMake(56, 149, 20, 20);
            self.ballRed.frame = CGRectMake(86, 249, 20, 20);
            position = 2;
        }
        else if (position == 2){
            self.ball.frame = CGRectMake(264, 309, 20, 20);
            self.ballGrey.frame = CGRectMake(244, 149, 20, 20);
            self.ballRed.frame = CGRectMake(214, 249, 20, 20);
            
            position=3;
        }
        else if (position == 3){
            self.ball.frame = CGRectMake(264, 119, 20, 20);
            self.ballGrey.frame = CGRectMake(244, 279, 20, 20);
            self.ballRed.frame = CGRectMake(214, 179, 20, 20);
            position = 4;
        }
        else{
            self.ball.frame = CGRectMake(26, 119, 20, 20);
            self.ballGrey.frame = CGRectMake(56, 279, 20, 20);
            self.ballRed.frame = CGRectMake(86, 179, 20, 20);
            
            position = 1;
        }
        ;
    }completion:nil];
}

- (void)viewDidUnload
{
    [timer invalidate];
    timer = nil;
    self.ball = nil;
    self.ballGrey = nil;
    self.ballRed = nil;
    

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Modally showing levels view controller. 
-(IBAction)goToLevelStack{
    levelsViewController *levelVC;
    [self moveToNextView:levelVC withId:@"navLevelsVC"];
}

//Modally showing options view controller. 
-(IBAction)goToOption{
    optionsViewController *optionsVC;
    [self moveToNextView:optionsVC withId:@"navOptionsVC"];
}


//Modally showing about us view controller. 
-(IBAction)goToAboutUs{
    aboutUsViewController *aboutUsVC;
    [self moveToNextView:aboutUsVC withId:@"aboutUsVC"];
}

//this code modally move the view controller.
-(void) moveToNextView:(UIViewController *)viewControllerToCall withId:(NSString *)uniqueId{
    UIStoryboard *storyBoard = self.storyboard; 
    viewControllerToCall = [storyBoard instantiateViewControllerWithIdentifier: uniqueId];
    [self presentViewController:viewControllerToCall animated:YES completion:NULL];
}

@end
