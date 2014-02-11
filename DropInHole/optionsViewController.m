//
//  options View Controller.m
//  firstview
//
//  Created by Dhaval Shah on 5/11/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "optionsViewController.h"


@implementation optionsViewController{
    highScoresViewController *highScoresVC;
    NSUserDefaults *userPreference;
    NSDictionary *userData;
    NSString *userName;
    NSString *plistPath;
    NSString *plistPathInBundle;
}

@synthesize backButton,vibrationSwitch, soundSwitch;
@synthesize  highscores, ballInHoleSound, userNameField;

//This method is called when the Main Menu button is touched.
-(IBAction)goBackToMainMenu{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

// this method copies the plist to app's Document folder if not present and initialize the user name text field with value in UserData.plist file. 
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Look in Documents for an existing plist file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    plistPath = [documentsDirectoryPath stringByAppendingPathComponent: @"UserData.plist"];
    
    // If it's not there, copy it from the bundle
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSError *error;
    
    if ( ![fileManger fileExistsAtPath:plistPath] ) {
    
        plistPathInBundle = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"plist"];
        [fileManger copyItemAtPath:plistPathInBundle toPath:plistPath error: &error];
    }		
    
    userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    userName = [userData objectForKey:@"Username"];
    
    userNameField.text = userName;
    
    userPreference = nil;
    userPreference = [NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBar.topItem.title = @"Options";
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"vibrateState"] compare:@"ON"] == NSOrderedSame){
        self.vibrationSwitch.on =YES;
    }
    
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"soundState"] compare:@"ON"] == NSOrderedSame){
        self.soundSwitch.on = YES;
    }
    
    NSString *soundFilePath =[[NSBundle mainBundle] pathForResource:@"goal" ofType:@"caf"];
    CFURLRef soundURL = (__bridge CFURLRef)[ NSURL fileURLWithPath:soundFilePath];
    AudioServicesCreateSystemSoundID(soundURL, &ballInHoleSound);
    
}


- (void)viewDidUnload
{
    self.vibrationSwitch = nil;
    self.soundSwitch = nil;
    self.userNameField = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//This method close keyboard when Done button is pressed and save user name in text field.
-(IBAction) dismissKeyboard:(id) sender{
    [sender resignFirstResponder];
    [self addUserName:userNameField.text];
}

//This method make device vibrate.
- (void) vibrate{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

//This method is called when vibrate switch is on/off and saves the user preference in NSDefaults object.
-(IBAction) vibrateOnOff{
    NSString *value = @"ON";
    
    if(vibrationSwitch.on){
        [userPreference setObject:value forKey:@"vibrateState"];
        [self vibrate];
    }
    else {
        value = @"OFF";
        [userPreference setObject:value forKey:@"vibrateState"];
    }
}  

//This method plays sound.
-(void) playSound{
    AudioServicesPlaySystemSound(ballInHoleSound);
}


//This method is called when sound switch is on/off and saves the user preference in NSDefaults object.
-(IBAction) soundOnOff{
    NSString *value = @"ON";
    
    if(soundSwitch.on){
        [userPreference setObject:value forKey:@"soundState"];
        [self playSound];
    }
    else {
        value = @"OFF";
        [userPreference setObject:value forKey:@"soundState"];
    }
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"vibrateState"] compare:@"ON"] == NSOrderedSame){
        self.vibrationSwitch.on =YES;
    }
    
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"soundState"] compare:@"ON"] == NSOrderedSame){
        self.soundSwitch.on = YES;
    }
}

// This method save the username in plist file.
-(void) addUserName:(NSString *)username{
    [userData setValue:username forKey:@"Username"];
    [userData writeToFile:plistPath atomically:YES];
}


@end
