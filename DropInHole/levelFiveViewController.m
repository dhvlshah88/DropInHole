//
//  levelFiveViewController.m
//  DropInHole
//
//  Created by Dhaval Shah on 04/06/2012.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import "levelFiveViewController.h"

static sqlite3 *database = nil;
static sqlite3_stmt *updateStatement = nil;

@implementation levelFiveViewController
{
    AppDelegate *appDelegateObj;
    UIAccelerometer *gameAccelerometer;
    UITapGestureRecognizer *singleTapRecognizer;
    optionsViewController *options;
    NSTimer *levelFiveTimer;
    UIAlertView *alert;
}

@synthesize  blueBall, levelCountDown, levelId, ballStartingCoord,
ballSize, currentScore, previousScore, boundarySize, levelFive, 
viewStartCoords, powerView, totalSeconds, secondLeft, ballInHoleSound, bonusScore;

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
    
    levelId = 5;
    currentScore = 0;
    bonusScore = 100;
    totalSeconds = 9.0;
    secondLeft = 9.0;
    
    //Create tap gesture instance and set its properties to bring navigation bar in front.
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadNavigationBar)];
    [singleTapRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:singleTapRecognizer];
    singleTapRecognizer.delegate = self;
    
    //Create accelerometer instance and set its properties.
    gameAccelerometer = [UIAccelerometer sharedAccelerometer];
    gameAccelerometer.updateInterval = 1.0f/30.0;
    gameAccelerometer.delegate = nil;
    
    //Initialization of ivars.
    ballStartingCoord = CGPointMake(self.blueBall.frame.origin.x, self.blueBall.frame.origin.y);
    ballSize = CGSizeMake(blueBall.frame.size.width, blueBall.frame.size.height);
    boundarySize.width = levelFive.screenBounds.width - 2 * levelFive.startingCoordinates.x;
    boundarySize.height = levelFive.screenBounds.height - 2 * levelFive.startingCoordinates.y;
    
    //Hide the navigation bar.
    self.navigationController.navigationBar.alpha =0.0;
    
    //Create a app delegate instance to access its ivars.
    appDelegateObj = [[UIApplication sharedApplication] delegate];
    
    //Create options veiw  controller instance
    options = [[optionsViewController alloc] init];
    
    //This method is called to load the sound file.
    [self loadSoundFile];
    
    alert = [[UIAlertView alloc] initWithTitle:@"LEVEL 5" message:nil delegate:self     
                             cancelButtonTitle:@"Play" otherButtonTitles:nil];
    [alert show];
    
}

//This method is called after the user press play button on alert view. Here accelerometer's delegate is set and level's timer is fired.
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{    
    if(alertView==alert)
    {     
        alert = nil;
        gameAccelerometer.delegate =self;
        levelFiveTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountDown) userInfo:nil repeats:YES];
        
    }
}

//Set all the IBOutlets to nil when view unloads.
- (void)viewDidUnload
{
    self.blueBall = nil;
    self.levelCountDown = nil;
    gameAccelerometer = nil;
    levelFiveTimer = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

//This method is used to create rectangle area in the view where the tap gesture doesn't work. Due to this method the "Choose Level" back navigation button works.
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint noTapArea = CGPointMake([touch locationInView:self.view].x, [touch locationInView:self.view].y);
    
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

//This method is called whenever device moves or tilts in any direction. This is the place where the ball is moved, stopped by the blocks and checks whether ball passed from power or destination hole.

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    CGPoint newCoord;
    
    newCoord.x = blueBall.frame.origin.x + (acceleration.x * 15);
    newCoord.y = blueBall.frame.origin.y - (acceleration.y * 15);
    
    
    if(newCoord.y <= levelFive.startingCoordinates.y){
        newCoord.y =levelFive.startingCoordinates.y + 1;
    }
    
    if(newCoord.y >= levelFive.screenBounds.height - (levelFive.startingCoordinates.y + ballSize.height)){
        newCoord.y = levelFive.screenBounds.height - (levelFive.startingCoordinates.y + ballSize.height) - 1;
    }
    
    
    //This code doesn't allow ball to move outside the inner boundary and left side of block 1.
    if(newCoord.x <= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].origin.x){
        
        if(newCoord.x <= levelFive.startingCoordinates.x){
            newCoord.x = levelFive.startingCoordinates.x + 1;
        }
        
        //Below is the condition to block ball to go through left side of block 1.
        if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].origin.x - ballSize.width) {
            if((newCoord.y > levelFive.startingCoordinates.y &&
                newCoord.y < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].size.height + levelFive.startingCoordinates.y - 1) || 
               (newCoord.y >=(levelFive.screenBounds.height - levelFive.startingCoordinates.y + [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:0] CGRectValue].size.height - ballSize.height + 1) &&
                newCoord.y < levelFive.screenBounds.height - levelFive.startingCoordinates.y - ballSize.height)){
                   
                   newCoord.x = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].origin.x - ballSize.width - 1;
                   
               } 
        }
    }
    
    //This code doesn't allow ball to move through right side of block 1 and left side of block 2.
    if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].origin.x  &&
       newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].origin.x){
        
        
        //Below is the condition to block ball to go through right side of block 1.
        float ub1RightEdge = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].origin.x + levelFive.upperMovingBlock.width;
        if(newCoord.x <= ub1RightEdge &&
           ((newCoord.y >= levelFive.startingCoordinates.y && 
             newCoord.y < ([[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].size.height + levelFive.startingCoordinates.x - 1)) 
            || 
            (newCoord.y >=(levelFive.screenBounds.height - levelFive.startingCoordinates.y + [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:0] CGRectValue].size.height - ballSize.height + 1) &&
             newCoord.y < (levelFive.screenBounds.height - levelFive.startingCoordinates.y - ballSize.height)))){
                
                newCoord.x = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].origin.x + levelFive.upperMovingBlock.width + 1;  
                
            } 
        
        //Below is the condition to block ball to go through left side of block 2.
        if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].origin.x - ballSize.width)
        {
            if((newCoord.y > levelFive.startingCoordinates.y && newCoord.y < ([[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].size.height + levelFive.startingCoordinates.y)) || 
               (newCoord.y >=(levelFive.screenBounds.height - levelFive.startingCoordinates.y + [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:1] CGRectValue].size.height - ballSize.height) &&  newCoord.y < levelFive.screenBounds.height - levelFive.startingCoordinates.y - ballSize.height)){
                
                newCoord.x = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].origin.x - ballSize.width - 1;
                
            }
        }
        
        //SHRINK POWER
        //This condition activates the shrink power and shrinks ball in the level.
        if(newCoord.y <= 50.0 && [[powerView.drawStars objectAtIndex:0] boolValue]){
            [self activatePowerOfType:1];
        }
    }
    
    
    
    //This code doesn't allow ball to move through right side of block 2 and left side of block 3.
    if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].origin.x  &&
       newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].origin.x){
        
        //Below is the condition to block ball to go through right side of block 2.
        float ub2RightEdge = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].origin.x + levelFive.upperMovingBlock.width;
        if(newCoord.x <= ub2RightEdge &&
           ((newCoord.y >= levelFive.startingCoordinates.y &&
             newCoord.y < ([[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].size.height + levelFive.startingCoordinates.x - 1)) || 
            (newCoord.y >=(levelFive.screenBounds.height - levelFive.startingCoordinates.y + [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:1] CGRectValue].size.height - ballSize.height + 1) &&
             newCoord.y < (levelFive.screenBounds.height - levelFive.startingCoordinates.y - ballSize.height)))){
                
                newCoord.x = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].origin.x + levelFive.upperMovingBlock.width + 1;  
                
            } 
        
        
        //Below is the condition to block ball to go through left side of block 3.
        if(newCoord.x > [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].origin.x - ballSize.width)
        {
            if((newCoord.y >= levelFive.startingCoordinates.y && 
                newCoord.y < ([[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].size.height + levelFive.startingCoordinates.y - 1)) || 
               (newCoord.y >=(levelFive.screenBounds.height - levelFive.startingCoordinates.y + [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:2] CGRectValue].size.height - ballSize.height + 1) && 
                newCoord.y < levelFive.screenBounds.height - levelFive.startingCoordinates.y - ballSize.height)){
                   
                   newCoord.x = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].origin.x - ballSize.width - 1;
                   
               }
        }
    }
    
    
    
    //This code doesn't allow ball to move through right side of block 3 and left side of block 4.
    if(newCoord.x >=[[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].origin.x &&
       newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x){
        
        
        //Below is the condition to block ball to go through right side of block 3.
        float ub3RightEdge = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].origin.x + levelFive.upperMovingBlock.width;
        if(newCoord.x <= ub3RightEdge &&
           ((newCoord.y >= levelFive.startingCoordinates.y &&
             newCoord.y < ([[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].size.height + levelFive.startingCoordinates.x - 1)) || 
            (newCoord.y >=(levelFive.screenBounds.height - levelFive.startingCoordinates.y + [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:2] CGRectValue].size.height - ballSize.height + 1) &&
             newCoord.y < (levelFive.screenBounds.height - levelFive.startingCoordinates.y - ballSize.height)))){
                newCoord.x = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].origin.x + levelFive.upperMovingBlock.width + 1;  
            } 
        
        //Below is the condition to block ball to go through left side of block 4.
        if(newCoord.x > [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x - ballSize.width)
        {
            if((newCoord.y >= levelFive.startingCoordinates.y && 
                newCoord.y < ([[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].size.height + levelFive.startingCoordinates.y - 1)) || 
               (newCoord.y >=(levelFive.screenBounds.height - levelFive.startingCoordinates.y + [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:3] CGRectValue].size.height - ballSize.height + 1) && 
                newCoord.y < levelFive.screenBounds.height - levelFive.startingCoordinates.y - ballSize.height)){
                   
                   newCoord.x = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x - ballSize.width - 1;
                   
               }
        }
        
    }
    
    
    //This code doesn't allow ball to move through left side of block 4.
    if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x){
        
        //Below is the condition to block ball to go through left side of block 4.
        float ub4RightEdge = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x + levelFive.upperMovingBlock.width;
        if(newCoord.x <= ub4RightEdge &&
           (((newCoord.y >= levelFive.startingCoordinates.y &&
              newCoord.y < ([[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].size.height + levelFive.startingCoordinates.x - 1)) || 
             (newCoord.y >=(levelFive.screenBounds.height - levelFive.startingCoordinates.y + [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:3] CGRectValue].size.height - ballSize.height + 1) &&
              newCoord.y < (levelFive.screenBounds.height - levelFive.startingCoordinates.y - ballSize.height))))){
                 newCoord.x = [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x + levelFive.upperMovingBlock.width + 1;  
             } 
        
        
        
        if(newCoord.x >= levelFive.screenBounds.width - (levelFive.startingCoordinates.x + ballSize.width)){
            newCoord.x = levelFive.screenBounds.width - (levelFive.startingCoordinates.x + ballSize.width) - 1;
        }
        
        //DOUBLE POWER
        //This condition activates the shrink power and shrinks ball in the level.
        if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3]CGRectValue].origin.x - ballSize.width/2 &&
           newCoord.y >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3]CGRectValue].size.height && [[powerView.drawStars objectAtIndex:1] boolValue]){
            [self activatePowerOfType:2];
        }
        
    } 
    
    
    
    //condition for first upper and lower block horizontal edge.
    if(newCoord.y <= levelFive.startingCoordinates.y + [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].size.height &&
       newCoord.y > levelFive.startingCoordinates.y + [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].size.height - 5 &&
       newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].origin.x - (ballSize.width/2) &&
       newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].origin.x + levelFive.upperMovingBlock.width - (ballSize.width/2)){
       
        newCoord.y = levelFive.startingCoordinates.y + [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].size.height;
        
    }
        
    float lb1StartingYCoord = levelFive.screenBounds.height - levelFive.startingCoordinates.y - [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:0] CGRectValue].size.height - ballSize.height;
    
    if(newCoord.y >= lb1StartingYCoord &&
       newCoord.y < lb1StartingYCoord + 5 &&
       newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].origin.x - ballSize.width &&
       newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:0] CGRectValue].origin.x + levelFive.upperMovingBlock.width - (ballSize.width/2)){
        
        newCoord.y = lb1StartingYCoord - 1;
    
    }
    
    
   //condition for second upper and lower block horizontal edge.
    if(newCoord.y <= levelFive.startingCoordinates.y + [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].size.height){
        
        if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].origin.x - (ballSize.width/2) &&
           newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].origin.x + levelFive.upperMovingBlock.width - (ballSize.width/2)){ 
            newCoord.y = levelFive.startingCoordinates.y + [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].size.height;
        }
    }
    
    float lb2StartingYCoord = (levelFive.screenBounds.height - levelFive.startingCoordinates.y - [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:1] CGRectValue].size.height - ballSize.height);
    
    if(newCoord.y >= lb2StartingYCoord){
        if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].origin.x - (ballSize.width/2) &&
           newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:1] CGRectValue].origin.x + levelFive.upperMovingBlock.width - (ballSize.width/2)){
            newCoord.y = lb2StartingYCoord - 1;
        }
    }
    
    //condition for third upper and lower block horizontal edge.
    if(newCoord.y <= levelFive.startingCoordinates.y + [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].size.height){
        if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].origin.x - (ballSize.width/2) &&
           newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].origin.x + levelFive.upperMovingBlock.width - (ballSize.width/2)){
            newCoord.y = levelFive.startingCoordinates.y + [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].size.height;
        }
    }
    
    float lb3StartingYCoord = levelFive.screenBounds.height - levelFive.startingCoordinates.y + [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:2] CGRectValue].size.height - ballSize.height;
    if(newCoord.y >= lb3StartingYCoord){
        if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].origin.x - (ballSize.width/2) &&
           newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:2] CGRectValue].origin.x + levelFive.upperMovingBlock.width - (ballSize.width/2)){
            newCoord.y = lb3StartingYCoord - 1;
        }
    }
    
    
    //condition for fourth upper and lower block horizontal edge.
    if(newCoord.y <= levelFive.startingCoordinates.y + [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].size.height){
        
        if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x - (ballSize.width/2) &&
           newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x + levelFive.upperMovingBlock.width - (ballSize.width/2)){
            newCoord.y = levelFive.startingCoordinates.y + [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].size.height;
        }
    }
    
    float lb4StartingYCoord = (levelFive.screenBounds.height - levelFive.startingCoordinates.y + [[levelFive.arrayOfLowerMovingBlocks objectAtIndex:3] CGRectValue].size.height - ballSize.height);
    
    if(newCoord.y >= lb4StartingYCoord){
        if(newCoord.x >= [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x - (ballSize.width/2) &&
           newCoord.x < [[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x + levelFive.upperMovingBlock.width - (ballSize.width/2)){
            newCoord.y = lb4StartingYCoord - 1;
        }
    }
    
    
    if(blueBall.center.x >= levelFive.destinationHole.origin.x && 
       blueBall.center.y >= levelFive.destinationHole.origin.y){
        [self ballInDestHole];
    }
    
    
    self.blueBall.frame = CGRectMake(newCoord.x, newCoord.y, ballSize.width, ballSize.height);
}



//This message is called when ball touches the star or power.
-(void) activatePowerOfType:(int)powertype{
    switch (powertype) {
        case 1:
            ballSize = CGSizeMake(ballSize.width/2, ballSize.height/2);
            self.blueBall.frame = CGRectMake(self.blueBall.frame.origin.x, self.blueBall.frame.origin.y, ballSize.width, ballSize.height);
            [powerView.drawStars replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]]; 
            [powerView setNeedsDisplayInRect:CGRectMake(86.0, 25.0, 50, 50)];
            break;
            
        case 2:
            
            ballSize = CGSizeMake(ballSize.width*2, ballSize.height*2);
            self.blueBall.frame = CGRectMake(self.blueBall.frame.origin.x, self.blueBall.frame.origin.y, ballSize.width, ballSize.height);
            [powerView.drawStars replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:NO]]; 
            [powerView setNeedsDisplayInRect:CGRectMake([[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].origin.x - 10,[[levelFive.arrayOfUpperMovingBlocks objectAtIndex:3] CGRectValue].size.height + levelFive.startingCoordinates.y, 50, 50)];
            break;
            
        default:
            break;
    }
}

//This method is called when the timer is fired and it calculates the time left and updates progress bar view.
-(void) startCountDown {
    const double timePassed = 1.0;
    secondLeft = secondLeft - timePassed;
    
    if(secondLeft == 0){
        [levelFiveTimer invalidate];
        levelFiveTimer = nil;
        
        alert = [[UIAlertView alloc] initWithTitle:@"GAME OVER" 
                                           message:@"Times Up!!"
                                          delegate:nil
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        gameAccelerometer.delegate = nil;
    }
    
    self.levelCountDown.progress = secondLeft/totalSeconds;
    
    if(secondLeft < 6 && self.levelCountDown.progressTintColor != [UIColor redColor]){
        self.levelCountDown.progressTintColor = [UIColor redColor];
    }
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
        sqlite3_bind_text(updateStatement, 2, [@"Level 5" UTF8String], -1, SQLITE_TRANSIENT);
        
        if (SQLITE_DONE != sqlite3_step(updateStatement)) 
            NSAssert1(0, @"Error while updating in Level 5. '%s'", sqlite3_errmsg(database));
        sqlite3_reset(updateStatement);
    }
}

// This method is called whenever ball is in destination hole. This stops timer, calculates score based on time left and plays sound and vibrates if they are set on.
-(void)ballInDestHole{
    [levelFiveTimer invalidate];
    blueBall.hidden = YES;
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"vibrateState"] compare:@"ON"] == NSOrderedSame){
        [options vibrate];
    }
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"soundState"] compare:@"ON"] == NSOrderedSame){
        AudioServicesPlaySystemSound(ballInHoleSound);
    }
    
    gameAccelerometer.delegate = nil;
    
    currentScore = 2000 + bonusScore * secondLeft;
    [self updateScoreForLevel:currentScore];
    
    
    NSString *alertMessage = [NSString stringWithFormat:@"Your scores is %d", currentScore];
    
    alert = [[UIAlertView alloc] initWithTitle:@"CONGRATULATIONS!!" 
                                       message:alertMessage
                                      delegate:nil
                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

-(void) viewDidDisappear:(BOOL)animated{
    [levelFiveTimer invalidate];
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
