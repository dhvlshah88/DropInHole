//
//  levelOneViewController.m
//  
//
//  Created by Dhaval Shah on 5/11/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "levelOneViewController.h"

static sqlite3 *database = nil;
static sqlite3_stmt *updateStatement = nil;

@implementation levelOneViewController{
    optionsViewController *options;
    NSTimer *levelOneTimer;
    UIAccelerometer *gameAccelerometer;
    UITapGestureRecognizer *singleTapRecognizer;
    AppDelegate *appDelegateObj;
    UIAlertView *alert;
}

@synthesize backgroundImage, blueBall, ballStartingCoord, ballSize, boundarySize, levelOne, badHoles, 
badHoleSize, levelId, currentScore, previousScore, 
totalSeconds, secondLapsed, ballInHoleSound, bonusScore;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    levelId = 1;
    currentScore = 0;
    bonusScore = 50;
    totalSeconds = 40;
    secondLapsed = 1;
    
    //Create tap gesture instance and set its properties to bring navigation bar in front.
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadNavigationBar)];
    [singleTapRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:singleTapRecognizer];
    singleTapRecognizer.delegate = self;
    
    //Hide the navigation bar.
    self.navigationController.navigationBar.alpha = 0.0;
    
    //Create accelerometer instance and set its properties.
    gameAccelerometer = [UIAccelerometer sharedAccelerometer];
    gameAccelerometer.updateInterval = 1.0f/30.0;
    gameAccelerometer.delegate = nil;
    
    //Initialization of ivars.
    ballStartingCoord = CGPointMake(self.blueBall.frame.origin.x, self.blueBall.frame.origin.y);
    ballSize = CGSizeMake(blueBall.frame.size.width, blueBall.frame.size.height);
    boundarySize.width = levelOne.screenBounds.width - 2 * levelOne.startingCoordinates.x;
    boundarySize.height = levelOne.screenBounds.height - 2 * levelOne.startingCoordinates.y;
    
    badHoleSize.width = badHoleSize.height = 31;
    badHoles = [[NSMutableArray alloc] initWithCapacity:8];
    [badHoles addObject: [NSValue valueWithCGRect:CGRectMake(243, 22, badHoleSize.width, badHoleSize.height)]];
    [badHoles addObject: [NSValue valueWithCGRect:CGRectMake(226, 121, badHoleSize.width, badHoleSize.height)]];
    [badHoles addObject: [NSValue valueWithCGRect:CGRectMake(33, 125, badHoleSize.width, badHoleSize.height)]];
    [badHoles addObject: [NSValue valueWithCGRect:CGRectMake(93, 214, badHoleSize.width, badHoleSize.height)]];
    [badHoles addObject: [NSValue valueWithCGRect:CGRectMake(252, 259, badHoleSize.width, badHoleSize.height)]];
    [badHoles addObject: [NSValue valueWithCGRect:CGRectMake(33, 300, badHoleSize.width, badHoleSize.height)]];
    [badHoles addObject: [NSValue valueWithCGRect:CGRectMake(214, 315, badHoleSize.width, badHoleSize.height)]];
    [badHoles addObject: [NSValue valueWithCGRect:CGRectMake(48, 409, badHoleSize.width, badHoleSize.height)]];
    
    //Create a app delegate instance to access its ivars.
    appDelegateObj = [[UIApplication sharedApplication] delegate];
    
    //Create options veiw  controller instance
    options = [[optionsViewController alloc] init];
    
    //This method is called to load the sound file.
    [self loadSoundFile];
 
    alert = [[UIAlertView alloc] initWithTitle:@"LEVEL 1" message:nil delegate:self     
                             cancelButtonTitle:@"Play" otherButtonTitles:nil];
    [alert show];
}

//This method is called after the user press play button on alert view. Here accelerometer's delegate is set and level's timer is fired.
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{    
    if(alertView==alert)
    {     
        alert = nil;
        gameAccelerometer.delegate =self;
        levelOneTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(circularCountDown) userInfo:nil repeats:YES]; 
    }
}

//This method gives circular timer effect and is called when timer fires.
-(void) circularCountDown{
    
    if(totalSeconds == self.secondLapsed){
        [levelOneTimer invalidate];
        levelOneTimer = nil;
        
        alert = [[UIAlertView alloc] initWithTitle:@"GAME OVER" 
                                                        message:@"Times Up!!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        gameAccelerometer.delegate = nil;
    }
    self.levelOne.totalSeconds = totalSeconds;
    self.levelOne.secondLapsed = secondLapsed;
    [self.levelOne setNeedsDisplayInRect:levelOne.destinationHole];
    secondLapsed += 1;
}


//This method is used to create rectangle area in the view where the tap gesture doesn't work. Due to this method the "Choose Level" back navigation button works.
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    CGPoint noTapArea = CGPointMake([touch locationInView:levelOne].x, [touch locationInView:levelOne].y);
    
    if(noTapArea.x<65 && noTapArea.y<44){
        return NO;
    }

    return YES;
}

//This method is called when screen is tapped. It sets alpha value of navigation bar with animation. 
-(void)loadNavigationBar {
    
    if (self.navigationController.navigationBar.alpha==1) {
        [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.navigationController.navigationBar.alpha=0;
        } completion:nil];  
    }
    else
    {
        [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.navigationController.navigationBar.alpha=1;
        } completion:nil]; 
    }
    
}

//Set all the IBOutlets to nil when view unloads.
- (void)viewDidUnload
{
    singleTapRecognizer =nil;
    self.blueBall=nil;
    self.levelOne = nil;
    self.backgroundImage = nil;
    gameAccelerometer=nil;
    self.badHoles = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientzation:(UIInterfaceOrientation)interfaceOrientation
{
       return NO;
}


//This method is called whenever device moves or tilts in any direction. This is the place where the ball is moved, stopped by the blocks and checks whether ball is in bad hole or destination hole.
-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    CGPoint newCoord;
    
    newCoord.x = blueBall.frame.origin.x + (acceleration.x * 15);
    newCoord.y = blueBall.frame.origin.y - (acceleration.y * 15);
    
    
    //The four if loop below will keep the ball within the inner boundary in view. 
    if(newCoord.x <= levelOne.startingCoordinates.x){
        newCoord.x = levelOne.startingCoordinates.x + 1;
    }
    
    if(newCoord.y <= levelOne.startingCoordinates.y){
        newCoord.y =levelOne.startingCoordinates.y + 1;
    }
    
    if(newCoord.x >= levelOne.screenBounds.width - (levelOne.startingCoordinates.x + ballSize.width)){
        newCoord.x = levelOne.screenBounds.width - (levelOne.startingCoordinates.x + ballSize.width) - 1;
    }
    
    if(newCoord.y >= levelOne.screenBounds.height - (levelOne.startingCoordinates.y + ballSize.height)){
        newCoord.y = levelOne.screenBounds.height - (levelOne.startingCoordinates.y + ballSize.height) - 1;
    }
    
    
    
    
    //This code is for second 1/5th sector on the screen.
    if(newCoord.y > levelOne.startingCoordinates.y && 
       newCoord.y < [[levelOne.arrayOfBlocks objectAtIndex:0] CGRectValue].origin.y + (levelOne.block.height/2)){
        
        
        //This if loop block the ball at top boundary of block 1.
        if(newCoord.y >= [[levelOne.arrayOfBlocks objectAtIndex:0] CGRectValue].origin.y - ballSize.height &&
           newCoord.x > levelOne.startingCoordinates.x &&
           newCoord.x < (levelOne.block.width + levelOne.startingCoordinates.x - 1)){
            newCoord.y = [[levelOne.arrayOfBlocks objectAtIndex:0] CGRectValue].origin.y - ballSize.height;
        }
        
        if(newCoord.y >= ([[levelOne.arrayOfBlocks objectAtIndex:0] CGRectValue].origin.y - ballSize.height) && 
           newCoord.y < ([[levelOne.arrayOfBlocks objectAtIndex:0] CGRectValue].origin.y + (levelOne.block.height/2)) &&
           newCoord.x <= (levelOne.block.width + levelOne.startingCoordinates.x) &&
           newCoord.x > (levelOne.block.width + levelOne.startingCoordinates.x - 1)){
            newCoord.x = levelOne.block.width + levelOne.startingCoordinates.x + 1;
        }
        
        //This code for first bad hole
        [self checkBallInBadHoleAreaOfSection:1];
    }
    
    
    //This code is for second 1/5th sector on the screen.
    if(newCoord.y > [[levelOne.arrayOfBlocks objectAtIndex:0] CGRectValue].origin.y + (levelOne.block.height/2) &&
       newCoord.y <= [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y + (levelOne.block.height/2)){
        
        if(newCoord.y >= ([[levelOne.arrayOfBlocks objectAtIndex:0] CGRectValue].origin.y + (levelOne.block.height/2)) && 
           newCoord.y < ([[levelOne.arrayOfBlocks objectAtIndex:0] CGRectValue].origin.y + levelOne.block.height) && 
           newCoord.x <= (levelOne.block.width + levelOne.startingCoordinates.x) &&
           newCoord.x > (levelOne.block.width + levelOne.startingCoordinates.x - 1)){
            newCoord.x = levelOne.block.width + levelOne.startingCoordinates.x + 1;
        }
        
        if(newCoord.y <= ([[levelOne.arrayOfBlocks objectAtIndex:0] CGRectValue].origin.y + levelOne.block.height) &&
           newCoord.x < (levelOne.block.width + levelOne.startingCoordinates.x)){
            newCoord.y = [[levelOne.arrayOfBlocks objectAtIndex:0] CGRectValue].origin.y + levelOne.block.height;
        }
        
        if(newCoord.y >= [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y - ballSize.height &&
           newCoord.y < [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y &&
           newCoord.x > [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.x - ballSize.width && 
           newCoord.x < [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.x + levelOne.block.width){
            newCoord.y = [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y - ballSize.height;
        }
        
        if(newCoord.y >=[[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y - (ballSize.height/2) &&
           newCoord.y < [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y + (levelOne.block.height/2) && 
           newCoord.x >=[[levelOne.arrayOfBlocks objectAtIndex:1]CGRectValue].origin.x - ballSize.width &&
           newCoord.x < [[levelOne.arrayOfBlocks objectAtIndex:1]CGRectValue].origin.x){
            newCoord.x =[[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.x - ballSize.width - 1;
        }
        
        [self checkBallInBadHoleAreaOfSection:2];
    }
    
    //This code is for third 1/5th sector of the screen. 
    if(newCoord.y > ([[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y + (levelOne.block.height/2)) &&
       newCoord.y <= ([[levelOne.arrayOfBlocks objectAtIndex:2] CGRectValue].origin.y + (levelOne.block.height/2))){
        
        if(newCoord.y >= [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y + (levelOne.block.height/2) &&
           newCoord.y < [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y + levelOne.block.height && 
           newCoord.x >= [[levelOne.arrayOfBlocks objectAtIndex:1]CGRectValue].origin.x - ballSize.width &&
           newCoord.x < [[levelOne.arrayOfBlocks objectAtIndex:1]CGRectValue].origin.x - ballSize.width + 1){
            newCoord.x = [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.x - ballSize.width - 1;
        }
        
        if(newCoord.y <= [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y + levelOne.block.height &&
           newCoord.x >= [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.x - ballSize.width &&
           newCoord.x < [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.x + levelOne.block.width){
            newCoord.y = [[levelOne.arrayOfBlocks objectAtIndex:1] CGRectValue].origin.y + levelOne.block.height;          
        }
        
        if(newCoord.y >= [[levelOne.arrayOfBlocks objectAtIndex:2] CGRectValue].origin.y - ballSize.height &&
           newCoord.x > levelOne.startingCoordinates.x &&
           newCoord.x < (levelOne.block.width + levelOne.startingCoordinates.x - 1)){
            newCoord.y = [[levelOne.arrayOfBlocks objectAtIndex:2] CGRectValue].origin.y - ballSize.height;
        }
        
        if(newCoord.y >= ([[levelOne.arrayOfBlocks objectAtIndex:2] CGRectValue].origin.y - ballSize.height) && 
           newCoord.y < ([[levelOne.arrayOfBlocks objectAtIndex:2] CGRectValue].origin.y + (levelOne.block.height/2)) && 
           newCoord.x <= (levelOne.block.width + levelOne.startingCoordinates.x) &&
           newCoord.x > (levelOne.block.width + levelOne.startingCoordinates.x - 1)){
            newCoord.x = levelOne.block.width + levelOne.startingCoordinates.x + 1;
        }
        
        [self checkBallInBadHoleAreaOfSection:3];
    }
    
    //This code is for fourth 1/5th sector on the screen.
    if(newCoord.y > ([[levelOne.arrayOfBlocks objectAtIndex:2] CGRectValue].origin.y + (levelOne.block.height/2)) &&
       newCoord.y <= ([[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y + (levelOne.block.height/2))){
        
        if(newCoord.y >= ([[levelOne.arrayOfBlocks objectAtIndex:2] CGRectValue].origin.y + (levelOne.block.height/2)) && 
           newCoord.y < ([[levelOne.arrayOfBlocks objectAtIndex:2] CGRectValue].origin.y + levelOne.block.height) && 
           newCoord.x <= (levelOne.block.width + levelOne.startingCoordinates.x) &&
           newCoord.x > (levelOne.block.width + levelOne.startingCoordinates.x - 1)){
            newCoord.x = levelOne.block.width + levelOne.startingCoordinates.x + 1;
        } 
        
        if(newCoord.y <= ([[levelOne.arrayOfBlocks objectAtIndex:2] CGRectValue].origin.y + levelOne.block.height) &&
           newCoord.x < (levelOne.block.width + levelOne.startingCoordinates.x)){
            newCoord.y = [[levelOne.arrayOfBlocks objectAtIndex:2] CGRectValue].origin.y + levelOne.block.height;
        }
        
        if(newCoord.y >= [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y - ballSize.height &&
           newCoord.y < [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y &&
           newCoord.x >= [[levelOne.arrayOfBlocks objectAtIndex:3]CGRectValue].origin.x - ballSize.width){
            newCoord.y = [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y - ballSize.height;
        }
        
        if(newCoord.y >= [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y - ballSize.height &&
           newCoord.y < [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y + (levelOne.block.height/2) && 
           newCoord.x >= [[levelOne.arrayOfBlocks objectAtIndex:3]CGRectValue].origin.x - ballSize.width &&
           newCoord.x < [[levelOne.arrayOfBlocks objectAtIndex:3]CGRectValue].origin.x){
            newCoord.x = [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.x - ballSize.width - 1;
        }
        
        [self checkBallInBadHoleAreaOfSection:4];
        
    }
    
    //This code is for fifth 1/5th sector on the screen.
    if(newCoord.y > ([[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y + (levelOne.block.height/2)) &&
       newCoord.y <= levelOne.screenBounds.height - levelOne.startingCoordinates.y){
        
        if(newCoord.y >= [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y + (levelOne.block.height/2) &&
           newCoord.y <=  [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y + levelOne.block.height && 
           newCoord.x >= [[levelOne.arrayOfBlocks objectAtIndex:3]CGRectValue].origin.x - ballSize.width &&
           newCoord.x <= [[levelOne.arrayOfBlocks objectAtIndex:1]CGRectValue].origin.x - ballSize.width + 1){
            newCoord.x = [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.x - ballSize.width - 1;
        }
        
        if(newCoord.y <= [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y + levelOne.block.height &&
           newCoord.x >= [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.x - ballSize.width &&
           newCoord.x <  [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.x + levelOne.block.width){
            newCoord.y = [[levelOne.arrayOfBlocks objectAtIndex:3] CGRectValue].origin.y + levelOne.block.height;          
        }
        
        [self checkBallInBadHoleAreaOfSection:5];
        
        if(blueBall.center.x >= levelOne.destinationHole.origin.x &&
           blueBall.center.y >= levelOne.destinationHole.origin.y){
            [self ballInDestHole];
        }
    }
    
    
    
    self.blueBall.frame = CGRectMake(newCoord.x, newCoord.y, ballSize.width, ballSize.height);
}


//This method checks whether the ball is bad hole area and drops it in bad hole. 
-(void)checkBallInBadHoleAreaOfSection: (int) sectionNo{
    
    
    switch (sectionNo) {
        case 1:
            if(blueBall.center.x > [[badHoles objectAtIndex:0] CGRectValue].origin.x && 
               blueBall.center.x < [[badHoles objectAtIndex:0] CGRectValue].origin.x + badHoleSize.width &&
               blueBall.center.y > [[badHoles objectAtIndex:0]CGRectValue].origin.y  &&
               blueBall.center.y < [[badHoles objectAtIndex:0] CGRectValue].origin.y + badHoleSize.height){
                [self ballInBadHole];
            }
            break;
            
        case 2:
            if(blueBall.center.x > [[badHoles objectAtIndex:1] CGRectValue].origin.x && 
               blueBall.center.x < [[badHoles objectAtIndex:1] CGRectValue].origin.x + badHoleSize.width &&
               blueBall.center.y > [[badHoles objectAtIndex:1]CGRectValue].origin.y  &&
               blueBall.center.y < [[badHoles objectAtIndex:1] CGRectValue].origin.y + badHoleSize.height){
                [self ballInBadHole];
            }
            
            if(blueBall.center.x > [[badHoles objectAtIndex:2] CGRectValue].origin.x && 
               blueBall.center.x < [[badHoles objectAtIndex:2] CGRectValue].origin.x + badHoleSize.width &&
               blueBall.center.y > [[badHoles objectAtIndex:2]CGRectValue].origin.y &&
               blueBall.center.y < [[badHoles objectAtIndex:2] CGRectValue].origin.y + badHoleSize.height){
                [self ballInBadHole];
            }
            break; 
            
        case  3:
            if(blueBall.center.x > [[badHoles objectAtIndex:3] CGRectValue].origin.x && 
               blueBall.center.x < [[badHoles objectAtIndex:3] CGRectValue].origin.x + badHoleSize.width &&
               blueBall.center.y > [[badHoles objectAtIndex:3]CGRectValue].origin.y  &&
               blueBall.center.y < [[badHoles objectAtIndex:3] CGRectValue].origin.y + badHoleSize.height){
                [self ballInBadHole];
            }   
            
            if(blueBall.center.x > [[badHoles objectAtIndex:4] CGRectValue].origin.x && 
               blueBall.center.x < [[badHoles objectAtIndex:4] CGRectValue].origin.x + badHoleSize.width &&
               blueBall.center.y > [[badHoles objectAtIndex:4]CGRectValue].origin.y  &&
               blueBall.center.y < [[badHoles objectAtIndex:4] CGRectValue].origin.y + badHoleSize.height){
                [self ballInBadHole]; 
            }
            break;
            
        case  4:
            if(blueBall.center.x > [[badHoles objectAtIndex:4] CGRectValue].origin.x && 
               blueBall.center.x < [[badHoles objectAtIndex:4] CGRectValue].origin.x + badHoleSize.width &&
               blueBall.center.y > [[badHoles objectAtIndex:4]CGRectValue].origin.y  &&
               blueBall.center.y < [[badHoles objectAtIndex:4] CGRectValue].origin.y + badHoleSize.height){
                [self ballInBadHole];
            } 
            
            if(blueBall.center.x > [[badHoles objectAtIndex:5] CGRectValue].origin.x && 
               blueBall.center.x < [[badHoles objectAtIndex:5] CGRectValue].origin.x + badHoleSize.width &&
               blueBall.center.y > [[badHoles objectAtIndex:5]CGRectValue].origin.y  &&
               blueBall.center.y < [[badHoles objectAtIndex:5] CGRectValue].origin.y + badHoleSize.height){
                [self ballInBadHole]; 
            }
            
            if(blueBall.center.x > [[badHoles objectAtIndex:6] CGRectValue].origin.x && 
               blueBall.center.x < [[badHoles objectAtIndex:6] CGRectValue].origin.x + badHoleSize.width &&
               blueBall.center.y > [[badHoles objectAtIndex:6]CGRectValue].origin.y  &&
               blueBall.center.y < [[badHoles objectAtIndex:6] CGRectValue].origin.y + badHoleSize.height){
                [self ballInBadHole];  
            }
            break;
            
        case 5:
            if(blueBall.center.x > [[badHoles objectAtIndex:7] CGRectValue].origin.x && 
               blueBall.center.x < [[badHoles objectAtIndex:7] CGRectValue].origin.x + badHoleSize.width &&
               blueBall.center.y > [[badHoles objectAtIndex:7]CGRectValue].origin.y  &&
               blueBall.center.y < [[badHoles objectAtIndex:7] CGRectValue].origin.y + badHoleSize.height){
                [self ballInBadHole];
            }
            break;
    }
    
}


// This method is called whenever ball is in bad hole area. This gives the ball dropping effect, put the ball  back to start position and vibrates if the vibration is on.
-(void)ballInBadHole{
    
    CGFloat alphaValue = 0.0f;
    if (blueBall.alpha==1.0f) {
        alphaValue =0.0f;
    }
    
    [UIView animateWithDuration:3.0f delay:0.5f options: UIViewAnimationCurveEaseInOut animations:^{
        blueBall.alpha = alphaValue;
        [blueBall removeFromSuperview];
    } completion:^(BOOL finished) {
        [self.levelOne addSubview: blueBall];
        blueBall.frame  = CGRectMake(ballStartingCoord.x, ballStartingCoord.y, ballSize.width, ballSize.height);
        blueBall.alpha = 1.0f;
//        [UIView animateWithDuration:0.5f animations:^{
//            blueBall.frame  = CGRectMake(ballStartingCoord.x, ballStartingCoord.y, ballSize.width, ballSize.height);
//            blueBall.alpha=1.0f;
//        }];
    }];
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"vibrateState"] compare:@"ON"] == NSOrderedSame){
        [options vibrate];
    }
    
}

// This method is called whenever ball is in destination hole. This stops timer, calculates score based on time left and plays sound if it is set on.
-(void)ballInDestHole{
    
    [levelOneTimer invalidate];
    levelOneTimer = nil;
    blueBall.hidden = YES;
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"soundState"] compare:@"ON"] == NSOrderedSame){
        AudioServicesPlaySystemSound(ballInHoleSound);
    }
    
    currentScore = 1000 + bonusScore * (totalSeconds - secondLapsed);
    [self updateScoreForLevel:currentScore];

    gameAccelerometer.delegate = nil;
    
    NSString *alertMessage = [NSString stringWithFormat:@"Your scores is %d", currentScore];
    
    alert = [[UIAlertView alloc] initWithTitle:@"CONGRATULATIONS!!" 
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


// This methods updated the score generated in the table.
-(void) updateScoreForLevel:(int)score{
  
    if (sqlite3_open([[appDelegateObj getDBPath] UTF8String], &database) == SQLITE_OK) {    
        if(updateStatement == nil) {
            const char *sqlquery = "update levelTable set score = ? where levelName = ?";
            if(sqlite3_prepare_v2(database, sqlquery, -1, &updateStatement, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
        }
        
        //Bind the question marks with actual values
        sqlite3_bind_int(updateStatement, 1, score);
        sqlite3_bind_text(updateStatement, 2, [@"Level 1" UTF8String], -1, SQLITE_TRANSIENT);
        
        if (SQLITE_DONE != sqlite3_step(updateStatement)) 
            NSAssert1(0, @"Error while updating in Level 1. '%s'", sqlite3_errmsg(database));
        sqlite3_reset(updateStatement);
    }
}



-(void) viewDidDisappear:(BOOL)animated{
    [levelOneTimer invalidate];
    gameAccelerometer.delegate = nil;
    [super viewDidDisappear:animated];
}

// This method loads the sound file.
-(void) loadSoundFile{
    NSString *soundFilePath =[[NSBundle mainBundle] pathForResource:@"goal" ofType:@"caf"];
    CFURLRef soundURL = (__bridge CFURLRef)[ NSURL fileURLWithPath:soundFilePath];
    AudioServicesCreateSystemSoundID(soundURL, &ballInHoleSound);
}

@end 