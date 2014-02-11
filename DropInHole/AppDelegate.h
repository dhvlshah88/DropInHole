//
//  AppDelegate.h
//  DropInHole
//
//  Created by Kalpesh Marlecha on 5/14/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class optionsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    UIWindow *window;
    
	//To hold a list of Scores objects
	NSMutableArray *levelArray;
}

@property (nonatomic, retain) NSMutableArray *levelArray;

- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet optionsViewController *options;

@end
