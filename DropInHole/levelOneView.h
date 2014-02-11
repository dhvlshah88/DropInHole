//
//  levelOneView.h
//  DropInHole
//
//  Created on Dhaval Shah 5/22/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface levelOneView : UIView

//This ivars will store dimension of block, device screen, destination hole, shadow offset for bad holes or pit holes and shadow offset for destination hole.
@property CGSize block, screenBounds, hole, shadowOffset, shadowOffsetForDestHole;

//This ivars will store starting coordinates of inner boundary, starting coordinates and center coordinates of destination hole
@property CGPoint startingCoordinates, finishHoleCoordinates, destinationHoleCenter;

//This ivars will store the border line width of inner boundary. 
@property CGFloat borderLineWidth;

//This ivars will store starting coordinates, width and heigth of inner boundary and destination hole.
@property CGRect innerBoundary, destinationHole;

//This ivars will store array of blocks.
@property (strong, nonatomic) NSMutableArray *arrayOfBlocks;

//This ivars will store the current graphic context.
@property CGContextRef context;

//This ivars will store total time in seconds given to user to complete the level and seconds lapsed will playing.
@property int totalSeconds, secondLapsed;

//This instance method is used to initialize all the ivars.
-(void) commonInitializer;


@end
