//
//  levelFiveView.h
//  DropInHole
//
//  Created by Dhaval Shah on 02/06/2012.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface levelFiveView : UIView{
    CGPoint blockStartingCoordinates;
}

//This ivars will store dimension of upper and lower block, device screen, destination hole, shadow offset for bad holes or pit holes and shadow offset for destination hole.
@property CGSize upperMovingBlock, lowerMovingBlock, screenBounds, hole, shadowOffset, shadowOffsetForDestHole;

//This ivars will store starting coordinates of inner boundary, starting coordinates and center coordinates of destination hole
@property CGPoint startingCoordinates, destinationHoleCoordinates, destinationHoleCenter;

//This ivars will store the border line width of inner boundary. 
@property CGFloat borderLineWidth;

//This ivars will store starting coordinates, width and heigth of inner boundary and destination hole.
@property CGRect innerBoundary, destinationHole;

//This ivars will store array of upper and lower rectangle blocks.
@property (strong, nonatomic) NSMutableArray *arrayOfUpperMovingBlocks, *arrayOfLowerMovingBlocks;

//This instance method is used to initialize all the ivars.
-(void) commonInitializer;

@end
