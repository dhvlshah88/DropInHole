//
//  levelTwoViewController.m
//  DropInHole
//
//  Created by vijay mysore on 5/28/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import "levelTwoViewController.h"
#import "levelsViewController.h"
#import "optionsViewController.h"

static sqlite3 *database = nil;
static sqlite3_stmt *updateStatement = nil;

@implementation levelTwoViewController{
     optionsViewController *options;
}

@synthesize playball;
@synthesize playNavigationBar;
@synthesize x,y,play,ballroll,goal,currentScore,previousScore, myLevelName;

// local variables
UIAccelerometer *accel;
NSTimer *timer;
int min,sec;
UIAlertView *alert;
int seconds;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// to update the score
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
            NSAssert1(0, @"Error while updating in Level 4. '%s'", sqlite3_errmsg(database));
        sqlite3_reset(updateStatement);
    }
}

- (NSString *) getDBPath {
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"myNewDatabase.sqlite"];
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

// Initialization code for the view
- (void)viewDidLoad
{   
    options = [[optionsViewController alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    accel = [UIAccelerometer sharedAccelerometer];
    accel.delegate=nil;
    accel.updateInterval=1.0f/25;
    [super viewDidLoad];
    
    myLevelName = @"Level 2";
    
    [self.view addGestureRecognizer:play];
    time1 = [[UILabel alloc] initWithFrame:CGRectMake(135, 440, 50, 17)];
    NSLog(@"Reached View Did Load - Level 2");
    
    //  NSLog(@"%@",[time1 text]);
    
    [time1 setText:@"01:00"];
    min=01,sec=00;
    seconds=0;

    
    [self.view addSubview:time1];
    
    
    x=playball.center.x;
    y=playball.center.y;
    
    NSLog(@"%@",time1.text);
    
    alert = [[UIAlertView alloc] initWithTitle:@"START PLAY" message:nil delegate:self     
                             cancelButtonTitle:@"PLAY" otherButtonTitles:nil];
    [alert show];
    
    NSString *ballrollpath =[[NSBundle mainBundle] pathForResource:@"ballroll" ofType:@"caf"];
    CFURLRef ballURL = (__bridge CFURLRef)[ NSURL fileURLWithPath:ballrollpath];
    AudioServicesCreateSystemSoundID(ballURL, &ballroll);
    
    NSString *goalpath =[[NSBundle mainBundle] pathForResource:@"goal" ofType:@"caf"];
    CFURLRef goalURL = (__bridge CFURLRef)[ NSURL fileURLWithPath:goalpath];
    AudioServicesCreateSystemSoundID(goalURL, &goal);

    self.navigationController.navigationBar.alpha = 0.0;
    
    for(int k=0; k < [appDelegate.levelArray count]; k++)
    {    
        // will load the value of previous score for the current Level.
        if( [myLevelName isEqualToString: [[appDelegate.levelArray objectAtIndex:k] levelName] ] )
            previousScore = [[[appDelegate.levelArray objectAtIndex:k] score] doubleValue];
        
    }
    NSLog(@"Final Value - %d", previousScore);
    
}


// alert view delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{    
    if(alertView==alert)
    {     
        accel.delegate =self;
        timer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer) userInfo:nil repeats:YES];   
    }
}


// update timer label
-(void) timer{
    seconds++; 
    sec--;
    if(sec<0){
        sec=59;
        min--;
        if(min<0)
        {
            
            accel.delegate=nil;
            [timer invalidate];
            timer=nil;
            currentScore=0;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Nice try\n Score = 0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
    }
    if(min==0&&sec<10)
    {
        [time1 setTextColor:[UIColor redColor]];
        
        time1.hidden=YES;
        time1.hidden=NO;
    }
    
    NSString *timestring = [[NSString alloc ]initWithFormat:@"%.2d:%.2d",min,sec];
    
    
    if(timer!=nil)
        [time1 setText:timestring];
}

//tap gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)play shouldReceiveTouch:(UITouch *)touch
{
    CGPoint  point = [touch locationInView:self.view];
    
    if(point.y<40)
        return NO;
    else
        return YES;
}

//Toggle Navigation Bar

- (IBAction)loadNavigationBar {
    
    
    
    if (self.navigationController.navigationBar.alpha==1) {
        accel.delegate=self;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.navigationController.navigationBar.alpha=0;} completion:nil]; 
        timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        
    }
    else
    {
        accel.delegate=nil;
        AudioServicesPlaySystemSound(ballroll);
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.navigationController.navigationBar.alpha=1;} completion:nil]; 
        [timer invalidate];
        timer=nil;
    }
    
}

// accelerometer delegate

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    
    
    
    if (y<=31) {
        BOOL inRange1=NO;
        if(x>30 && x<204)
            inRange1=YES;
        
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);
        
        if ((inRange1==YES) && y>=30) {
            y=30;
        }
    }
    else if(y<=71)
    {
        BOOL inRange2=NO;
        if ((x>30&&x<164)||(x==192)) 
            inRange2=YES;
        BOOL inRange1=NO;
        if(x>30 && x<204)
            inRange1=YES;
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);  
        if(inRange2 && y>71)
            y=71;
        if ((inRange1==YES) && y<57) {
            y=57;
        }
    }
    
    else if(y<=122)
    {
        BOOL inRange31 = NO,inRange32 = NO,inRange33=NO,inRange34=NO;
        if((x > 114 && x < 176)||(x>181 && x < 256))
            inRange31=YES;
        if(x<=147)
            inRange32=YES;
        if(x>147&&x<=181)
            inRange33=YES;
        if(x>181)
            inRange34=YES;
        
        BOOL inRange2=NO;
        if ((x>30&&x<164)||(x==192)) 
            inRange2=YES;
        
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);
        
        if(inRange31 && y>112)
            y=112;
        if(inRange32 && x>147)
            x=147;
        if (inRange33 && x>181)
            x=181;
        if (inRange33 && x<175)
            x=175;
        if (inRange34 && x<206)
            x=206;
        if(inRange2 && y<99)
            y=99;
    }
    else if(y<=168){
        
        BOOL inRange41=NO,inRange42=NO,inRange43=NO,inRange44=NO,inRange45=NO,inRange31 = NO;
        if((x > 114 && x < 176)||(x>181 && x < 256))
            inRange31=YES;
        if((x>155&&x<229)||(x>256&&x<x<273))
            inRange41=YES;
        if(x<=31)
            inRange42=YES;
        if(x>31&&x<=116)
            inRange43=YES;
        if(x>116&&x<=242)
            inRange44 =YES;
        if(x>242)
            inRange45 =YES;
        
        
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);
        
        if(inRange41 && y>152)
            y=152;
        if(inRange42 && x>31)
            x=31;
        if(inRange43 && x>116)
            x=116;
        if(inRange43 && x<48)
            x=48;
        if(inRange44 && x>242)
            x=242;
        if(inRange44 && x<142)
            x=142;
        if(inRange45 && x<268)
            x=268;
        if(inRange31 && y<138)
            y=138;
        
    }
    else if(y<=203){
        
        BOOL inRange51=NO,inRange52=NO,inRange53=NO,inRange54=NO,inRange55=NO,inRange41=NO;
        
        if((x>155&&x<229)||(x>250&&x<x<273))
            inRange41=YES;
        if((x>35 && x<99)|| (x>223 && x<257))
            inRange51=YES;
        if(x<=31)
            inRange52 = YES;
        if(x>31&&x<=116)
            inRange53=YES; 
        if(x>116&&x<=180)
            inRange54 =YES;
        if(x>180)
            inRange55 =YES;
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);    
        
        if(inRange51 && y>193)
            y=193;
        if(inRange52 && x>31)
            x=31;
        if(inRange53 && x>116)
            x=116;
        if(inRange53 && x<48)
            x=48;
        if(inRange54 && x>180)
            x=180;
        if(inRange54 && x<142)
            x=142;
        if(inRange55 && x<206)
            x=206;
        if(inRange41 && y<179)
            y=179;
        
    }
    else if(y<=244){
        BOOL inRange61=NO,inRange62=NO,inRange63=NO,inRange64=NO,inRange65=NO,inRange66=NO,inRange51=NO;
        if((x>35 && x<99)|| (x>223 && x<257))
            inRange51=YES;  
        if((x>=15&&x<40)||(x>95&&x<129)||(x>158&&x<192))
            inRange61=YES;
        if(x<=54)
            inRange62=YES;
        if(x>54 && x<=116)
            inRange63=YES;
        if(x>116&&x<=180)
            inRange64=YES;
        if(x>180&&x<=212)
            inRange65=YES;
        if(x>212)
            inRange66=YES;
        
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);    
        
        if(inRange61&&y>234)
            y=234;
        if(inRange51&&y<218)
            y=218;
        if(inRange62&&x>54)
            x=54;
        if(inRange63&&x>116)
            x=116;
        if(inRange63&&x<80)
            x=80;
        if(inRange64&&x>180)
            x=180;
        if(inRange64&&x<142)
            x=142;
        if(inRange65&&x>212)
            x=212;
        if(inRange65&&x<206)
            x=206;
        if(inRange66&&x<238)
            x=238;         
        
    }
    else if(y<=283)
    {
        BOOL inRange71=NO,inRange72=NO,inRange73=NO,inRange74=NO,inRange75=NO,inRange76=NO,inRange77=NO,inRange61=NO;
        if(x>194&&x<223)
            inRange71=YES;
        if(x<=31)
            inRange72=YES;
        if(x>31&&x<=55)
            inRange73=YES;
        if(x>55&&x<=86)
            inRange74=YES;
        if(x>86&&x<=148)
            inRange75=YES;
        if(x>148&&x<=222)
            inRange76=YES;
        if(x>212)
            inRange77=YES;
        if((x>=15&&x<40)||(x>95&&x<129)||(x>158&&x<192))
            inRange61=YES;
        
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);
        
        if(inRange71 && y>273)
            y=273;
        if(inRange61 && y<260)
            y=260;
        if(inRange72 && x>31)
            x=31;
        if(inRange73 && x>55)
            x=55;
        if(inRange73 && x<47)
            x=47;
        if(inRange74 && x>86)
            x=86;
        if(inRange74 && x<80)
            x=80;
        if(inRange75 && x>148)
            x=148;
        if(inRange75 && x<112)
            x=112;
        if(inRange76 && x>212)
            x=212;
        if(inRange76 && x<175)
            x=175;
        if(inRange77 && x<238)
            x=238;    
    }  
    else if (y<=324)
    {
        BOOL inRange81=NO,inRange82=NO,inRange83=NO,inRange84=NO,inRange85=NO,inRange86=NO,inRange87=NO,inRange71=NO;
        
        if((x>102 && x<192)||(x>228 && x<274))
            inRange81=YES;
        
        if(x<=31)
            inRange82=YES;
        if(x>31&&x<=55)
            inRange83=YES;
        if(x>55&&x<=86)
            inRange84=YES;
        if(x>86&&x<=148)
            inRange85=YES;
        if(x>148&&x<=212)
            inRange86=YES;
        if(x>212)
            inRange87=YES;
        if(x>194&&x<223)
            inRange71=YES;
        
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);
        
        if(inRange81 && y>314)
            y=314;
        if(inRange71 && y<300)
            y=300;
        if(inRange82 && x>31)
            x=31;
        if(inRange83 && x>55)
            x=55;
        if(inRange83 && x<47)
            x=47;
        if(inRange84 && x>86)
            x=86;
        if(inRange84 && x<80)
            x=80;
        if(inRange85 && x>148)
            x=148;
        if(inRange85 && x<112)
            x=112;
        if(inRange86 && x>212)
            x=212;
        if(inRange86 && x<175)
            x=175;
        if(inRange87 && x<238)
            x=238;    
    }
    else if(y<=363)
    {
        BOOL inRange91=NO,inRange92=NO,inRange93=NO,inRange94=NO,inRange95=NO,inRange81=NO;
        if(x>193&&x<256)
            inRange91=YES;
        if(x<=31)
            inRange92=YES;
        if(x>31&&x<=55)
            inRange93=YES;
        if(x>55&&x<=180)
            inRange94=YES;
        if(x>180)
            inRange95=YES;
        if((x>102 && x<192)||(x>228 && x<274))
            inRange81=YES;
        
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);
        
        if(inRange91 && y>354)
            y=354;
        if(inRange81 && y<341)
            y=341;
        if(inRange92 && x>31)
            x=31;
        if(inRange93 && x>55)
            x=55;
        if(inRange93 && x<47)
            x=47;
        if(inRange94 &&x>180)
            x=180;
        if(inRange94 && x<80)
            x=80;
        if(inRange95 && x<205)
            x=205;
        
    }
    
    else if(y<=403)
    {
        BOOL inRange101=NO,inRange102=NO,inRange103=NO,inRange104=NO,inRange91=NO;
        if(x>226 && x<256)
            inRange101=YES;
        if(x<=31)
            inRange102=YES;
        if(x>31 && x<=243)
            inRange103=YES;
        if(x>243)
            inRange104=YES;
        if(x>193&&x<256)
            inRange91=YES;  
        
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);
        
        if(inRange101 && y>394)
            y=394;
        if(inRange102 && x>31)
            x=31;
        if(inRange103 && x>243)
            x=243;
        if(inRange103 && x<47)
            x=47;
        if(inRange104 && x<268)
            x=268;
        if(inRange91 && y<381)
            y=381;
        
    } 
    
    else if(y<=435)
    {
        BOOL inRange101=NO,inRange111=NO,inRange112=NO,inRange113=NO;
        if(x>226 && x<256)
            inRange101=YES;
        if(x<=55)
            inRange111=YES;
        if(x>55 && x<=212)
            inRange112=YES;
        if(x>212)
            inRange113=YES;
        x =(playball.center.x + acceleration.x*100);
        y =(playball.center.y - acceleration.y*100);
        
        if(inRange101 && y<420)
            y=420;
        if(inRange111 && x>55)
            x=55;
        if(inRange112 && x>212)
            x=212;
        if(inRange112 && x<80)
            x=80;
        if(inRange113 && x<239)
            x=239;
        
        
    }
    
    
    else{
        
        {
            x =(playball.center.x + acceleration.x*100);
            y =(playball.center.y - acceleration.y*100);
        }    
    }
    
    if(x>=273)
    {
        x=273;
    }
    if(x<=15)
    {
        x=15;
    }
    if(y>=435)
    {
        y=435;
    }
    if(y<=17)
    {
        y=17;
    }
    if((x>(138-10)&&x<(138+10)) && (y>(387-10)&&y<(387+10))){
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.playball.alpha=0;
            self.playball.frame=CGRectMake(138,387, 25, 25);
        } completion:nil]; 
        accel.delegate=nil;
        [timer invalidate];
       
        //AudioServicesPlaySystemSound(goal);  
         currentScore = 240 - seconds*4;
        if([[[NSUserDefaults standardUserDefaults] stringForKey:@"vibrateState"] compare:@"ON"] == NSOrderedSame){
            [options vibrate];
        }
        
        if([[[NSUserDefaults standardUserDefaults] stringForKey:@"soundState"] compare:@"ON"] == NSOrderedSame){
            //[options playSound];
            AudioServicesPlaySystemSound(goal);
        }
 
    }
    
    //    NSLog(@"x=%g y=%g",x,y);
    self.playball.frame=CGRectMake(x, y, 25, 25);
    
    }




- (void)viewDidUnload
{
    [self setPlayNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) moveToNextView:(UIViewController *)viewControllerToCall withId:(NSString *)uniqueId{
    UIStoryboard *storyBoard = self.storyboard; 
    viewControllerToCall = [storyBoard instantiateViewControllerWithIdentifier: uniqueId];
    [self.navigationController pushViewController:viewControllerToCall animated:YES];
   // [self presentViewController:viewControllerToCall animated:YES completion:NULL];
}



- (IBAction)back:(id)sender {
   
    levelsViewController *levelVC;
    [self moveToNextView:levelVC withId:@"levelsVC"];
}

-(void) viewDidDisappear:(BOOL)animated{
    [timer invalidate];
    [super viewDidDisappear:animated];
}

@end
