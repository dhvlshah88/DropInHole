//
//  levelsViewController.m
//  DropInHole
//
//  Created by Dhaval Shah on 5/15/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import "levelsViewController.h"


@implementation levelsViewController
{
    AppDelegate *appDelegate;
    Level *levelsObj;
    levelOneViewController *levelOneVC;
    levelTwoViewController *levelTwoVC;
    ForLevel3ViewController *levelThreeVC;
    LevelFourVC *levelFourVC;
    levelFiveViewController *levelFiveVC;
    LevelBuilderViewController *levelSixVC;
    
    UIStoryboard *storyBoard;
}

@synthesize backButton;

//This action is used to go back to main menu view.
-(IBAction)goBackToMainMenu{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//Here table's data is reloaded everytime view appear's.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

// Getting instance of storyboard and appdelegate.
- (void)viewDidLoad
{
    [super viewDidLoad];
    storyBoard = self.storyboard;
    appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)viewDidUnload
{
    appDelegate=nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Here returning no of section to table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//Here returning no of rows to table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [appDelegate.levelArray count];
}

//Here level data is populated for table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"levels";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
    }
    
    levelsObj = [appDelegate.levelArray objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:22.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if([levelsObj.levelName isEqualToString: @"Level 6"]){
        cell.textLabel.text =  @"Level Builder";
    }else {
        cell.textLabel.text = levelsObj.levelName;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    return cell;
}

//Here when cell is selected corresponding level is pushed on the stack programmatically.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    levelsObj = [appDelegate.levelArray objectAtIndex:indexPath.row];
    NSString *uniqueID = (NSString *) levelsObj.levelName;
    
    switch(indexPath.row){
        case 0:
            levelOneVC = [storyBoard instantiateViewControllerWithIdentifier:uniqueID];
            [self.navigationController pushViewController:levelOneVC animated:YES];
            break;
        case 1:
            levelTwoVC = [storyBoard instantiateViewControllerWithIdentifier:uniqueID];
            [self.navigationController pushViewController:levelTwoVC animated:YES];
            break;
        case 2:
            levelThreeVC = [storyBoard instantiateViewControllerWithIdentifier:uniqueID];
            [self.navigationController pushViewController:levelThreeVC animated:YES];
            break;
        case 3:
            levelFourVC = [storyBoard instantiateViewControllerWithIdentifier:uniqueID];
            [self.navigationController pushViewController:levelFourVC animated:YES];
            break;
        case 4:
            levelFiveVC = [storyBoard instantiateViewControllerWithIdentifier:uniqueID];
            [self.navigationController pushViewController:levelFiveVC animated:YES];
            break;
        case 5:
            levelSixVC = [storyBoard instantiateViewControllerWithIdentifier:uniqueID];
            [self.navigationController pushViewController:levelSixVC animated:YES];
            break;
    }
}

//Setting the title.
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.topItem.title = @"Choose Levels";
}

@end
