//
//  LevelBuilderViewController.m
//  DropInHole
//
//  Created by vijay mysore on 6/7/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import "LevelBuilderViewController.h"
#import "optionsViewController.h"

@implementation LevelBuilderViewController

@synthesize shapes,picker,fillcolor,pathcolor,interface,rectangles,width,height,x,y,back,intermediate,ball,xcor,ycor,speed,scroll,linewidth,gradient,navigation, goal,play;


UIAccelerometer *accel;
CGRect ballcordinates;
bool showalert=YES;


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
    
}
// vibrate on reaching the goal
-(void) vibrate{
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"vibrateState"] compare:@"ON"] == NSOrderedSame){
        
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
}


//picker delegate for coloumns
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component==0)
        return [shapes count];
    if(component==1)
        return [fillcolor count];
    if(component==2)
        return [pathcolor count];
    
    return 0;
    
}

//picker delegate for populating each row of the coloumn
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component==0)
        return [shapes objectAtIndex:row];
    if(component ==1)
        return [fillcolor objectAtIndex:row];
    if(component ==2)
        return [pathcolor objectAtIndex:row];
    
    else return 0;
    
    
}

//text field delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{   
    if(textField == x)
    {   
        if([x.text floatValue]<10 || [x.text floatValue]>290)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OUT OF RANGE" message:@"should be in range 10 to 290" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }}
    if(textField == y)
    {
        if([y.text floatValue]<40 || [y.text floatValue]>400)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OUT OF RANGE" message:@"should be in range 40 to 400" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    if(textField == speed)
    {
        if([speed.text integerValue]<0 || [speed.text integerValue]>4)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OUT OF RANGE" message:@"should be in range 0 to 4" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    if(textField == linewidth)
    {
        if([linewidth.text integerValue]<1 || [linewidth.text integerValue]>5)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OUT OF RANGE" message:@"should be in range 1 to 10" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
int i=0,j=0;

// draw the object onto the page

-(IBAction)draw:(id)sender{
    
    
    if(([x.text length]!=0) && ([y.text length]!=0) && ([height.text length]!=0) && ([width.text length]!=0) && ([speed.text length]!=0) && ([linewidth.text length]!=0)){    
    if([picker selectedRowInComponent:0]==1)
        
    { 
        
        
        draw* drawrect = [[draw alloc] initWithFrame:CGRectMake([x.text floatValue],[y.text floatValue],[width.text floatValue]+5,[height.text floatValue]+5)];
        drawrect.hidden=YES;
        drawrect.backgroundColor = [UIColor clearColor];
        drawrect.fcolor=[picker selectedRowInComponent:1];
        drawrect.pcolor=[picker selectedRowInComponent:2];
        drawrect.speed=[speed.text integerValue];
        drawrect.linewidth=[linewidth.text intValue];
        if(gradient.on)
            drawrect.isGradient=YES;
        else
            drawrect.isGradient=NO;   
        [rectangles addObject:drawrect];
        [self.view addSubview:[rectangles objectAtIndex:j]];
        [[rectangles objectAtIndex:j] setNeedsDisplay];
        
        
    }   
    else if([picker selectedRowInComponent:0]==0)
    {
        circle* drawcircle =[[circle alloc] initWithFrame:CGRectMake([x.text floatValue],[y.text floatValue],[width.text floatValue],[height.text floatValue])];
        
        drawcircle.hidden=YES;
        drawcircle.backgroundColor=[UIColor clearColor];
        drawcircle.fcolor=[picker selectedRowInComponent:1];
        drawcircle.pcolor=[picker selectedRowInComponent:2];
        drawcircle.speed=[speed.text intValue];
        drawcircle.linewidth=[linewidth.text intValue];
        if(gradient.on)
            drawcircle.isGradient=YES;
        else
            drawcircle.isGradient=NO; 
        [rectangles addObject:drawcircle];
        [self.view addSubview:[rectangles objectAtIndex:j]];
        [[rectangles objectAtIndex:j] setNeedsDisplay];
    }
    
    j++;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter all the details" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

// Undo last drawing action


-(IBAction)undo:(id)sender{
    
    UIView *rect;
    j--;
    rect =[rectangles objectAtIndex:j];
    [rect removeFromSuperview];
    [rectangles  removeObjectAtIndex:j];
    
}
// to view what changes you have made to your level 

-(IBAction)gotoview:(id)sender{
    interface.hidden =YES;
    UIView *rect;
    for(int j=0;j<rectangles.count;j++)
    {
        rect=[rectangles  objectAtIndex:j];
        rect.hidden=NO;
        
    }
    self.navigationController.navigationBar.hidden = YES;
    back.hidden=NO;
    intermediate.hidden=NO;
    
    
}

// go back from the view back to the building the level

-(IBAction)backfromview:(id)sender{
    
    UIView *rect;
    for(int j=0;j<rectangles.count;j++)
    {
        rect=[rectangles  objectAtIndex:j];
        rect.hidden=YES;
        
    }
    interface.hidden=NO;
    back.hidden=YES;
    intermediate.hidden=YES;
    showalert = YES;
    self.navigationController.navigationBar.hidden = NO;

}


// start playing the level


-(IBAction)play:(id)sender{
    
    interface.hidden =YES;
    intermediate.hidden=NO;
    ball.hidden=NO;
    UIView *rect;
    for(int j=0;j<rectangles.count;j++)
    {
        rect=[rectangles  objectAtIndex:j];
        rect.hidden=NO;
        
    }
    ball.hidden=NO;
    accel.delegate=(id)self;
    
    
    
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{ 
  // handle this when the view is loaded for the first time
    
    
    [scroll setScrollEnabled:YES];
    [scroll setContentSize:CGSizeMake(320, 400)];
    rectangles=[NSMutableArray arrayWithCapacity:25];
    shapes = [NSMutableArray arrayWithCapacity:3];  
    [shapes addObject:@"circle"];
    [shapes addObject:@"rectangle"];
    fillcolor =[NSMutableArray arrayWithCapacity:5];
    [fillcolor addObject:@"red"];
    [fillcolor addObject:@"green"];
    [fillcolor addObject:@"blue"];
    [fillcolor addObject:@"gray"];
    [fillcolor addObject:@"brown"];
    pathcolor =[NSMutableArray arrayWithCapacity:5];
    [pathcolor addObject:@"red"];
    [pathcolor addObject:@"green"];
    [pathcolor addObject:@"blue"];
    [pathcolor addObject:@"gray"];
    [pathcolor addObject:@"brown"];    
	back.hidden=YES;
    intermediate.hidden=YES;
    accel = [UIAccelerometer sharedAccelerometer];
    //   accel.delegate=nil;
    accel.updateInterval=1.0f/5;
    xcor=ball.center.x;
    ycor=ball.center.y;
    
    NSString *goalpath =[[NSBundle mainBundle] pathForResource:@"goal" ofType:@"caf"];
    CFURLRef goalURL = (__bridge CFURLRef)[ NSURL fileURLWithPath:goalpath];
    AudioServicesCreateSystemSoundID(goalURL, &goal);    
}

// local variables
float tempx,tempy;
UIAlertView* alert1;

//navigation bar toggeling

- (IBAction)loadNavigationBar {
    
    
    
    if (self.navigationController.navigationBar.alpha==1) {
        accel.delegate=(id)self;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.navigationController.navigationBar.alpha=0;} completion:nil]; 
        
        
    }
    else
    {
        accel.delegate=nil;
       
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.navigationController.navigationBar.alpha=1;} completion:nil]; 
        
    }
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)play shouldReceiveTouch:(UITouch *)touch
{
    CGPoint  point = [touch locationInView:self.view];
    
    if(point.y<40)
        return NO;
    else
        return YES;
}


// accelerometer delegate

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    xcor  =(ball.center.x + acceleration.x*100);
    ycor  =(ball.center.y - acceleration.y*100);
    if(xcor <0)
        xcor=0;
    if(xcor > 310)
        xcor =310;
    if(ycor<0)
        ycor=0;
    if(ycor>460)
        ycor = 460;
    
    if((xcor > 290 && xcor < 310)&&(ycor >425 && ycor < 455))
    {   
        accel.delegate=nil;
        
        ball.hidden=YES;
        
        if(showalert==YES)
        {   
            alert1 = [[UIAlertView alloc] initWithTitle:@"levelComplete" message:@"" delegate:self cancelButtonTitle:@"restart" otherButtonTitles:@"modifylevel", nil];
            [alert1 show];   
            showalert=NO;    
        }
        [self vibrate];
        if([[[NSUserDefaults standardUserDefaults] stringForKey:@"soundState"] compare:@"ON"] == NSOrderedSame){
            //[options playSound];
            AudioServicesPlaySystemSound(goal);
        }
    }
    
    
    ball.frame = CGRectMake(xcor, ycor, ball.frame.size.width, ball.frame.size.height);
    
    
    draw *rect;
    for(int j=0;j<rectangles.count;j++)
    {
        rect=[rectangles  objectAtIndex:j];
        if(rect.frame.origin.x>300)
            rect.frame = CGRectMake(0, rect.frame.origin.y, rect.frame.size.width, rect.frame.size.height);
        else
            rect.frame = CGRectMake(rect.frame.origin.x+(rect.speed)*5, rect.frame.origin.y, rect.frame.size.width, rect.frame.size.height); 
        
        if(CGRectIntersectsRect(rect.frame,ball.frame))
        {
            accel.delegate=nil;
            
            if(showalert==YES)
            {   
                alert1 = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"collission" delegate:self cancelButtonTitle:@"restart" otherButtonTitles:@"modifylevel", nil];
                [alert1 show];   
                showalert=NO;    
            }
            
            
        }
        
    }
    
    
    
    
    
}

// alert view delegate to handle button action



-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView==alert1)
    {     
        if (buttonIndex == 0) {
            
            [self restart];        
        }
        if(buttonIndex ==1)
        {
            [self backfromview:nil];
        }
               
        
    }
}

// restart on alert

-(void) restart{
    ball.hidden = NO;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        ball.alpha=0;
    } completion:nil];
    ball.frame = CGRectMake(290, 0, 27, 27);
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        ball.alpha=1;
    } completion:nil];
    showalert=YES;
    
    accel.delegate=(id)self;
    
    
}



-(void) moveToNextView:(UIViewController *)viewControllerToCall withId:(NSString *)uniqueId{
    UIStoryboard *storyBoard = self.storyboard; 
    viewControllerToCall = [storyBoard instantiateViewControllerWithIdentifier: uniqueId];
    [self presentViewController:viewControllerToCall animated:YES completion:NULL];
}



// to end first responder
-(IBAction)end:(id)sender
{
    [sender resignFirstResponder];
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated{
  
    accel.delegate = nil;
    [super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
