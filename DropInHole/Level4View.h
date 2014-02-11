//
//  Level4View.h
//  DropInHole
//
//  Created by Kalpesh Marlecha on 5/31/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Level4View : UIView

@property CGSize blockSize, screenBounds, hole, shadowOffset;
@property CGPoint startingCoordinates, finishHoleCoordinates;
@property CGFloat borderLineWidth;
@property CGRect innerBoundary, destinationHoleCoordinates;
@property (strong, nonatomic) NSMutableArray *arrayOfBlocks;

@property int i;

-(void) commonInitializer;

@end
