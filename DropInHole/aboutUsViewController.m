//
//  aboutus View Controller.m
//  firstview
//
//  Created by Dhaval Shah on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "aboutUsViewController.h"

@implementation aboutUsViewController

@synthesize aboutUsNavItem;

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Programmatically added a back button with a image.
    UIImage *backNavButtonImage = [UIImage imageNamed:@"back-button.png"];
    UIButton *backNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backNavButton setBackgroundImage:backNavButtonImage forState:UIControlStateNormal];
    backNavButton.frame = CGRectMake(10, 0, backNavButtonImage.size.width, backNavButtonImage.size.height);
    [backNavButton addTarget:self action:@selector(goBackToMainMenu) 
            forControlEvents:UIControlEventTouchUpInside ];
    
    aboutUsNavItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backNavButton];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
