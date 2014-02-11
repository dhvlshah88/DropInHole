//
//  NewLevelKalpesh.h
//  DropInHole-LevelTest
//
//  Created by Kalpesh Marlecha on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewLevel3View : UIView


@property CGSize blockSize, screenBounds, hole, shadowOffset;
@property CGPoint startingCoordinates, finishHoleCoordinates;
@property CGFloat borderLineWidth;
@property CGRect innerBoundary, destinationHoleCoordinates;
@property (strong, nonatomic) NSMutableArray *arrayOfBlocks;

-(void) commonInitializer;

@end
