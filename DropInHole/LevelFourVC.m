//
//  LevelFourVC.m
//  DropInHole
//
//  Created by Kalpesh Marlecha on 5/31/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import "LevelFourVC.h"
#import "levelsViewController.h"
#import "Level.h"
#import "AppDelegate.h"
#import "optionsViewController.h"


static sqlite3 *database = nil;
static sqlite3_stmt *updateStatement = nil;


@implementation LevelFourVC

// synthesize all in one shot
@synthesize blueBall, ballStartingCoord, viewStartCoords, ballSize, boundarySize;
@synthesize myLevelName, currentScore, previousScore, level4, goal, play;
@synthesize i;

UIAccelerometer *myAccelerator;
AppDelegate *appDelegate;
optionsViewController *options;
bool checkMilestone;

UIAlertView *alert; // to display alerts
UIAlertView *alert1;

//This method will update the database with new score
- (void) updateScore {
    
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
		NSAssert1(0, @"Error while updating in Level 4. '%s'", sqlite3_errmsg(database));
	sqlite3_reset(updateStatement);
    }
}

// will make the device vibrate
-(void) vibrate{
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"vibrateState"] compare:@"ON"] == NSOrderedSame)
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}



- (IBAction)loadNavigationBar {
    
    if (self.navigationController.navigationBar.alpha==1) {
        myAccelerator.delegate=self;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.navigationController.navigationBar.alpha=0;} completion:nil]; 
    }
    else
    {
        myAccelerator.delegate=nil;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.navigationController.navigationBar.alpha=1;} completion:nil]; 
    }
    
}

-(void) goToMainMenu{
    // End the game and show the option to go onto main menu
    myAccelerator.delegate = nil;
    
    alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:[[NSString alloc] initWithFormat:@"Please try again"] delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil];
    [alert show];
    
    blueBall.hidden = YES;
    self.navigationController.navigationBar.alpha = 1;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.alpha = 0;
    [self.view addGestureRecognizer:play];
    // initially the accelerometer will be nil, so that the user gets time to adjust himself for the GAMEPLAY
    myAccelerator.delegate = nil;
    alert1 = [[UIAlertView alloc] initWithTitle:@"START PLAY" message:nil delegate:self     
                             cancelButtonTitle:@"PLAY" otherButtonTitles:nil];
    [alert1 show];
	// Do any additional setup after loading the view.
    
    // to get onto the database values
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    //Accelerometer code to move the ball in view frame.
    myAccelerator = [UIAccelerometer sharedAccelerometer];
    myAccelerator.updateInterval = 3.0f/30.0;
    
    //Initialization of ivars.
    ballStartingCoord = CGPointMake(self.blueBall.frame.origin.x, self.blueBall.frame.origin.y);
    ballSize = CGSizeMake(blueBall.frame.size.width, blueBall.frame.size.height);
    boundarySize.width = level4.screenBounds.width - 2 * level4.startingCoordinates.x;
    boundarySize.height = level4.screenBounds.height - 2 * level4.startingCoordinates.y;
    
    // Initially this is set to False, so that user cannot goto next level, until it touches the stars
    checkMilestone = NO;
    
    myLevelName =  @"Level 4";
    currentScore = 0; //reset the current score to 0
    i = 0;
    
    // will get the appropriate value from DB
    for(int k=0; k < [appDelegate.levelArray count]; k++)
    {    
        // will load the value of previous score for the current Level.
        if( [myLevelName isEqualToString: [[appDelegate.levelArray objectAtIndex:k] levelName] ] )
            previousScore = [[[appDelegate.levelArray objectAtIndex:k] score] doubleValue];

    }
    
    //Load the files for playing the audio
    NSString *goalpath =[[NSBundle mainBundle] pathForResource:@"goal" ofType:@"caf"];
    CFURLRef goalURL = (__bridge CFURLRef)[ NSURL fileURLWithPath:goalpath];
    AudioServicesCreateSystemSoundID(goalURL, &goal);
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{    
    
    if(alertView==alert1) // to start the game play
        myAccelerator.delegate =self;

}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"myNewDatabase.sqlite"];
}


-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    CGPoint newCoord;
    
    newCoord.x = blueBall.frame.origin.x + (acceleration.x * 10);
    newCoord.y = blueBall.frame.origin.y - (acceleration.y * 10);
        
    //These four if loop below will keep the ball within the inner boundary in view. 
    if(newCoord.x <= level4.startingCoordinates.x)
        newCoord.x=level4.startingCoordinates.x+1;
    if(newCoord.y <= level4.startingCoordinates.y)
        newCoord.y = level4.startingCoordinates.y + 1;
    if(newCoord.x >= level4.screenBounds.width - (level4.startingCoordinates.x + ballSize.width))
        newCoord.x = level4.screenBounds.width - (level4.startingCoordinates.x + ballSize.width) - 1;
    if(newCoord.y >= level4.screenBounds.height - (level4.startingCoordinates.y + ballSize.height))
        newCoord.y = level4.screenBounds.height - (level4.startingCoordinates.y + ballSize.height) - 1;
    
//    NSLog(@"x = %f, y= %f",newCoord.x, newCoord.y);
    
    CGSize blockSize = CGSizeMake(40.0, 30.0);
    
    // Blocks will be used to end the game
    // Images will be used to increase the score
    CGRect block1, image1 = CGRectMake(145, 100, 30, 28); 
    CGRect block2, image2 = CGRectMake(145, 200, 30, 28);
    CGRect block3, image3 = CGRectMake(145, 300, 30, 28);
    CGRect block4, image4 = CGRectMake(145, 400, 30, 28);
    
    if(i < 450){
        if(i < 225){
            i+=10;
             block1 = CGRectMake(i, 100, blockSize.width, blockSize.height); 
             block2 = CGRectMake(225-i, 200, blockSize.width, blockSize.height);
             block3 = CGRectMake(i, 300, blockSize.width, blockSize.height);
             block4 = CGRectMake(225-i, 400, blockSize.width, blockSize.height);
        }
        else if( i >= 225 && i < 450){
             i+=10;
             block1 = CGRectMake(450-i, 100, blockSize.width, blockSize.height); 
             block2 = CGRectMake(i-255, 200, blockSize.width, blockSize.height);
             block3 = CGRectMake(450-i, 300, blockSize.width, blockSize.height);
             block4 = CGRectMake(i-225, 400, blockSize.width, blockSize.height);
        }
    }
    else i = 0;
    
    //These if conditions will end the game.
    if(CGRectIntersectsRect(block1, CGRectMake(newCoord.x, newCoord.y, ballSize.width,ballSize.height)) )
    {
        NSLog(@"In Intersection Rectangle -1");
        [self vibrate];
        [self goToMainMenu];
    }
    
    if (CGRectIntersectsRect (block2, CGRectMake(newCoord.x, newCoord.y, ballSize.width,ballSize.height) ))
    {
        NSLog(@"In Intersection Rectangle -2");
        [self vibrate];
        [self goToMainMenu];        
    }
    
    if (CGRectIntersectsRect (block3, CGRectMake(newCoord.x, newCoord.y, ballSize.width,ballSize.height) ))
    {
        NSLog(@"In Intersection Rectangle -3");
        [self vibrate];
        [self goToMainMenu ];
    }
    
    if (CGRectIntersectsRect (block4, CGRectMake(newCoord.x, newCoord.y, ballSize.width,ballSize.height) ))
    {
        NSLog(@"In Intersection Rectangle -4");
        [self vibrate];
        [self goToMainMenu ];
    }
    
    // Set the Milestone to TRUE, so that user will be able to go onto the next level, Increase the score and simultaneously update/increase the score
    if(CGRectIntersectsRect(image1, CGRectMake(newCoord.x, newCoord.y, 15,15)) || 
       CGRectIntersectsRect(image2, CGRectMake(newCoord.x, newCoord.y, 15,15)) || 
       CGRectIntersectsRect(image3, CGRectMake(newCoord.x, newCoord.y, 15,15)) ||
       CGRectIntersectsRect(image4, CGRectMake(newCoord.x, newCoord.y, 15,15)) )
    {        
        checkMilestone = YES;
        currentScore +=10;   
        score.text = [[NSString alloc] initWithFormat:@"Score = %d", currentScore ];
        nextLevel.text = @"Enabled";
    }
    
    //GOTO Next Level, and ball is now Hidden, also will display the alert accordingly, if the current score is greater than previous score, it will update the database with the new value.
    if(CGRectIntersectsRect(CGRectMake(225, 425, 30, 30), CGRectMake(newCoord.x, newCoord.y, 1,1))  &&checkMilestone)
    {    
        myAccelerator.delegate = nil;
        blueBall.hidden = YES;
        NSLog(@"%d - %d", previousScore, currentScore);
        
        if(previousScore < currentScore){
        alert = [[UIAlertView alloc] initWithTitle:@"Congrats" message:[[NSString alloc] initWithFormat:@"New High Score - %d", currentScore]delegate:self cancelButtonTitle:@"Main Menu" otherButtonTitles:nil];
            [self updateScore];
        }
        else{
            alert = [[UIAlertView alloc] initWithTitle:@"Level Completed" message:[[NSString alloc] initWithFormat:@"Score = %d", currentScore] delegate:self cancelButtonTitle:@"Main Menu" otherButtonTitles:nil];
        }
        [alert show];
        
        NSLog(@"Level Completed");
        [self vibrate];
        //play sound
        if([[[NSUserDefaults standardUserDefaults] stringForKey:@"soundState"] compare:@"ON"] == NSOrderedSame){
            AudioServicesPlaySystemSound(goal);
        }
        
    }
    self.blueBall.frame = CGRectMake(newCoord.x, newCoord.y, ballSize.width, ballSize.height);
    [self.view setNeedsDisplay];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// set all the values to nil, so that the application is consistent throughout
- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha = 1;
    myAccelerator.delegate = nil;
    [super viewDidDisappear:animated];
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