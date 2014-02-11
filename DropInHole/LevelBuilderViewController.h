//
//  LevelBuilderViewController.h
//  DropInHole
//
//  Created by vijay mysore on 6/7/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AudioToolbox/AudioServices.h>
#import "draw.h"
#import "circle.h"
#import "levelsViewController.h"
#define shape 0
#define fillcolors 1;
#define pathcolors 2;



@interface LevelBuilderViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>



//IVars of level builder

@property (strong,nonatomic) IBOutlet UIPickerView *picker;
@property (strong,nonatomic) NSMutableArray *shapes;
@property (strong,nonatomic) NSMutableArray *fillcolor;
@property (strong,nonatomic) NSMutableArray *pathcolor;
@property (strong,nonatomic) IBOutlet UIView *interface;
@property (strong,nonatomic) NSMutableArray *rectangles;
@property (strong,nonatomic) IBOutlet UITextField *x;
@property (strong,nonatomic) IBOutlet UITextField *y;
@property (strong,nonatomic) IBOutlet UITextField *width;
@property (strong,nonatomic) IBOutlet UITextField *height;
@property (strong,nonatomic) IBOutlet UIButton *back;
@property (strong,nonatomic) IBOutlet UIView *intermediate;
@property (strong,nonatomic) IBOutlet UIImageView *ball;
@property (strong,nonatomic) IBOutlet UITextField *speed;
@property (strong,nonatomic) IBOutlet UITextField *linewidth;
@property (strong,nonatomic) IBOutlet UIScrollView *scroll;
@property (strong,nonatomic) IBOutlet UISwitch *gradient;
@property (strong,nonatomic) IBOutlet UINavigationBar *navigation;
@property(nonatomic) SystemSoundID goal;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *play;
@property float xcor,ycor; 

//methods of level builders
-(IBAction)play:(id)sender;
-(IBAction)draw:(id)sender;
-(IBAction)end:(id)sender;
-(IBAction)undo:(id)sender;
-(IBAction)backfromview:(id)sender;
-(void) restart;
-(void) moveToNextView:(UIViewController *)viewControllerToCall withId:(NSString *)uniqueId;
-(void) vibrate;
@end
