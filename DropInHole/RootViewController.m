//
//  RootViewController.m
//  SQL
//
//

#import "RootViewController.h"
#import "Level.h"

@implementation RootViewController

@synthesize appDelegate;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of Rows to be loaded
    NSLog(@"%d",[appDelegate.levelArray count]);
    return [appDelegate.levelArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        //will reuse the cells
    }
	
	//Get the object from the array.
	Level *levelObj = [appDelegate.levelArray objectAtIndex:indexPath.row];

    cell.textLabel.text = [levelObj levelName];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@",[levelObj score] ];
    // will set the Level name and related score
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic -- create and push a new view controller
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // To get the access to database values
	appDelegate = [[UIApplication sharedApplication] delegate];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//reload the data in table
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}



@end

