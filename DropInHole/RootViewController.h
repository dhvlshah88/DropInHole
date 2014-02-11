//
//  RootViewController.h
//  SQL
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class Level, AddViewController;

@interface RootViewController : UITableViewController {
    
	AppDelegate *appDelegate;
	AddViewController *avController;
	UINavigationController *addNavigationController;
}

@property (strong, nonatomic) AppDelegate *appDelegate;

@end
