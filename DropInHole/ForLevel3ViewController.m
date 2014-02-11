//
//  ForKalpesh.m
//  DropInHole-LevelTest
//
//  Created by Kalpesh Marlecha on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForLevel3ViewController.h"
#import "AppDelegate.h"
#import "Level.h"
#import "optionsViewController.h"

static sqlite3 *database = nil;
static sqlite3_stmt *updateStatement = nil;

@implementation ForLevel3ViewController

@synthesize blueBall, ballStartingCoord, viewStartCoords, ballSize, boundarySize;
@synthesize myLevelName, currentScore, previousScore,playNavigationBar, level3, goal, play;
@synthesize nextLevelStateLabel, timeLabel;

AppDelegate *appDelegate;
int i;
BOOL checkMilestone = NO;
UIAccelerometer *myAccelerator;
UIAlertView *alert, *alert1;
int min,sec;
int seconds;
NSTimer *timer;
optionsViewController *options;

// Will make the device vibrate
-(void) vibrate{
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"vibrateState"] compare:@"ON"] == NSOrderedSame){
        //[options vibrate];
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
}

// Functionality of Navigation bar
- (IBAction)loadNavigationBar {
    
    if (self.navigationController.navigationBar.alpha==1) {
        myAccelerator.delegate=self;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.navigationController.navigationBar.alpha=0;} completion:nil]; 
        timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    }
    else
    {
        myAccelerator.delegate=nil;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.navigationController.navigationBar.alpha=1;} completion:nil]; 
        [timer invalidate];
        timer=nil;
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView==alert1)
    {     
        myAccelerator.delegate =self;
        timer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer) userInfo:nil repeats:YES];   
    }
    
}

-(void) timer{
    seconds++; 
    sec--;
    if(sec<0){
        sec=59;
        min--;
        if(min<0)
        {
            
            myAccelerator.delegate=nil;
            [timer invalidate];
            timer=nil;
            currentScore=0;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Nice try\n Score = 0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
    }
    if(min==0&&sec<10)
    {
        //changes the color of label to indicate the warning.
        [timeLabel setTextColor:[UIColor redColor]];
    }
    
    NSString *timestring = [[NSString alloc ]initWithFormat:@"%.2d:%.2d",min,sec];
    
    if(timer!=nil)
        [timeLabel setText:timestring];
}



-(void) goToMainMenu{
        // End the game and show the option to go onto main menu
    myAccelerator.delegate = nil;
    
    alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:[[NSString alloc] initWithFormat:@"Please try again"] delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil];
    [alert show];
    
    blueBall.hidden = YES;
    [timer invalidate];
    self.navigationController.navigationBar.alpha = 1;
}


// This method will update the values in database
- (void) updateScore {
	
    NSLog(@"%@", [self getDBPath]); // just to check if the correct values are displayed
    
    if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
        
        if(updateStatement == nil) {
            const char *sqlquery = "update levelTable set score = ? where levelName = ?";
            
            if(sqlite3_prepare_v2(database, sqlquery, -1, &updateStatement, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
        }
        
        //Bind the question marks with actual values
        sqlite3_bind_int(updateStatement, 1, currentScore);
        sqlite3_bind_text(updateStatement, 2, [myLevelName UTF8String], -1, SQLITE_TRANSIENT);
        
        if (SQLITE_DONE != sqlite3_step(updateStatement)) 
            NSAssert1(0, @"Error while updating in Level 3. '%s'", sqlite3_errmsg(database));
        
        sqlite3_reset(updateStatement);
    }
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"myNewDatabase.sqlite"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Load with default settings
    self.navigationController.navigationBar.alpha = 0;
    [self.view addGestureRecognizer:play];
    
    min=01,sec=30;
    seconds = 0;
    
    myLevelName = @"Level 3";
    currentScore = 0;
    i = 0;
    // To get access to the database
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    //Accelerometer code to move the ball in view frame.
    myAccelerator = [UIAccelerometer sharedAccelerometer];
    myAccelerator.updateInterval = 3.0f/30.0;
    myAccelerator.delegate = nil;
    
    //Initialization of ivars.
    ballStartingCoord = CGPointMake(self.blueBall.frame.origin.x, self.blueBall.frame.origin.y);
    ballSize = CGSizeMake(blueBall.frame.size.width, blueBall.frame.size.height);
    boundarySize.width = level3.screenBounds.width - 2 * level3.startingCoordinates.x;
    boundarySize.height = level3.screenBounds.height - 2 * level3.startingCoordinates.y;
    
    for(int k=0; k < [appDelegate.levelArray count]; k++)
    {    
        // will load the value of previous score for the current Level.
        if( [myLevelName isEqualToString:[[appDelegate.levelArray objectAtIndex:k] levelName] ] )
            previousScore = [[[appDelegate.levelArray objectAtIndex:k] score] doubleValue];
        
    }
    
    alert1 = [[UIAlertView alloc] initWithTitle:@"START PLAY" message:nil delegate:self     
                             cancelButtonTitle:@"PLAY" otherButtonTitles:nil];
    [alert1 show];
    
    //Initialize for the audio playback
    NSString *goalpath =[[NSBundle mainBundle] pathForResource:@"goal" ofType:@"caf"];
    CFURLRef goalURL = (__bridge CFURLRef)[ NSURL fileURLWithPath:goalpath];
    AudioServicesCreateSystemSoundID(goalURL, &goal);
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    CGPoint newCoord;
    
    newCoord.x = blueBall.frame.origin.x + (acceleration.x * 10);
    newCoord.y = blueBall.frame.origin.y - (acceleration.y * 10);
    
    
    //These four if loop below will keep the ball within the inner boundary in view. 
    if(newCoord.x <= level3.startingCoordinates.x)
        newCoord.x = level3.startingCoordinates.x + 1;
    
    if(newCoord.y <= level3.startingCoordinates.y)
        newCoord.y =level3.startingCoordinates.y + 1;
    
    if(newCoord.x >= level3.screenBounds.width - (level3.startingCoordinates.x + ballSize.width))
        newCoord.x = level3.screenBounds.width - (level3.startingCoordinates.x + ballSize.width) - 1;
    
    if(newCoord.y >= level3.screenBounds.height - (level3.startingCoordinates.y + ballSize.height))
        newCoord.y = level3.screenBounds.height - (level3.startingCoordinates.y + ballSize.height) - 1;
    
    if(i<300)
        i+=10;
    else 
        i = 0;
    
    //NSLog(@"x = %f, y= %f",newCoord.x, newCoord.y);
    
    CGRect block1 = CGRectMake(225, 265-i, 40, 40); //small ball in middle to increase score
    CGRect block2 = CGRectMake(200, 160-i, 110, 40);
    CGRect block3 = CGRectMake(200, 365-i, 110, 40);
    CGRect block4 = CGRectMake(100, (i), 10, 40);
   
    //This block will enable the flag to go into the nextlevel
    if (CGRectIntersectsRect (block1, CGRectMake(newCoord.x, newCoord.y, 15,15) ))
    {
        NSLog(@"In Intersection Rectangle -1");
        nextLevelStateLabel.text = @"Enabled";
        checkMilestone = YES;
    }
    
    // These 3 blocks will vibrate the device and end the game.
    if (CGRectIntersectsRect (block2, CGRectMake(newCoord.x, newCoord.y, 15,15) ))
    {
        NSLog(@"In Intersection Rectangle -2");
        [self vibrate];
        [self goToMainMenu];
    }
    
    if (CGRectIntersectsRect (block3, CGRectMake(newCoord.x, newCoord.y, 15,15) ))
    {
        NSLog(@"In Intersection Rectangle -3");
        [self vibrate];
        [self goToMainMenu];
    }
   
    if (CGRectIntersectsRect (block4, CGRectMake(newCoord.x, newCoord.y, 15,15) ))
    {
        NSLog(@"In Intersection Rectangle -4");
        [self vibrate];
        [self goToMainMenu];
    }

    // go to the next level if flag is enabled and you have reached the hole
    if(CGRectIntersectsRect(CGRectMake(225, 425, 30, 30), CGRectMake(newCoord.x, newCoord.y, 1,1)) && checkMilestone)
    {
        accelerometer.delegate = nil;
        blueBall.hidden = YES;
        currentScore = 360 - seconds*4;
        
        if(previousScore < currentScore){
            alert = [[UIAlertView alloc] initWithTitle:@"Congrats" message:[[NSString alloc] initWithFormat:@"New High Score - %d", currentScore] delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil];
            [alert show];
            [self updateScore];
        }
        else{
        alert = [[UIAlertView alloc] initWithTitle:@"Well Done" message:[[NSString alloc] initWithFormat:@"Score = %d", currentScore] delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil];
        [alert show];
        }
        [timer invalidate];
        [self vibrate];        
        
        //play sound
        if([[[NSUserDefaults standardUserDefaults] stringForKey:@"soundState"] compare:@"ON"] == NSOrderedSame){
            AudioServicesPlaySystemSound(goal);
        }
    }
    
    self.blueBall.frame = CGRectMake(newCoord.x, newCoord.y, ballSize.width, ballSize.height);
    [self.view setNeedsDisplay]; // to redraw the frame
}

// set all the values to nil, so that the application is consistent throughout
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    myAccelerator.delegate = nil;
    self.navigationController.navigationBar.alpha = 1;
    [timer invalidate];
    timer=nil;
    i=0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
