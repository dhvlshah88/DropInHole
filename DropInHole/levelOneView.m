//
//  levelOneView.m
//  DropInHole
//
//  Created on Dhaval Shah 5/22/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import "levelOneView.h"

@implementation levelOneView


@synthesize block, screenBounds, hole, startingCoordinates, 
borderLineWidth, shadowOffset, finishHoleCoordinates, 
innerBoundary, arrayOfBlocks, destinationHole, context,
shadowOffsetForDestHole, destinationHoleCenter, totalSeconds,
secondLapsed;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


//This method calls commonInitiallizer instance method.
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (nil != self)
	{
		[self commonInitializer];
	}
	
	return self;
}

//This initialize all the ivars required in the view.
-(void) commonInitializer{
    screenBounds = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    startingCoordinates= CGPointMake(15.0, 15.0);
    block = CGSizeMake(210.0, 40.0);
    hole = CGSizeMake(30.0, 30.0);
    borderLineWidth = 0.5;
    shadowOffset = CGSizeMake(7, 7);
    shadowOffsetForDestHole = CGSizeMake(0, 0);
    finishHoleCoordinates = CGPointMake(255, 425);
    destinationHoleCenter = CGPointMake(finishHoleCoordinates.x + round(hole.width/2), finishHoleCoordinates.y + round(hole.height/2));
    
    
    arrayOfBlocks = [[NSMutableArray alloc] initWithCapacity:4];
    [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(15, 60, block.width, block.height)]];
    [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(95, 160, block.width, block.height)]];
    [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(15, 260, block.width, block.height)]];
    [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(95, 365, block.width, block.height)]];
}


// This method draws all the elements of level one view.
- (void)drawRect:(CGRect)rect
{
    //Set up the current graphics context in order to draw. 
    context = UIGraphicsGetCurrentContext();
    
    //Below given code is used to draw thick boundary to fill space between screen boundary and inner boundary.
    CGContextSetLineWidth(context, 30);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGRect boundary = CGRectMake(0, 0, screenBounds.width, screenBounds.height);
    CGContextAddRect(context, boundary);
    CGContextDrawPath(context, kCGPathStroke);
    
    //Below given code is used to draw the inner boundary inside the context.
    CGContextSetLineWidth(context, borderLineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    innerBoundary = CGRectMake(startingCoordinates.x, startingCoordinates.y, screenBounds.width - (2 *startingCoordinates.x), screenBounds.height - (2 * startingCoordinates.y));
    CGContextAddRect(context, innerBoundary);
    CGContextDrawPath(context, kCGPathStroke);
    
    //Below give code is used to draw blocks, set shadow around them and soft out the graphics. 
    CGContextSaveGState(context);
    
    CGContextSetShadow (context, shadowOffset, 8);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    CGContextSetStrokeColorWithColor (context, [UIColor darkGrayColor].CGColor);
    
    CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
    
    for(int i=0; i<arrayOfBlocks.count; i++){
        CGContextAddRect(context, [[arrayOfBlocks objectAtIndex:i] CGRectValue]);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
   
    //Below given code is used to draw destination hole, shadow around it. 
    CGContextSaveGState(context);
    
    CGContextSetShadow (context, shadowOffsetForDestHole, 8);
    
    destinationHole = CGRectMake(finishHoleCoordinates.x, finishHoleCoordinates.y, hole.width, hole.height);
    
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextAddEllipseInRect(context, destinationHole);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
    
    
    //Below given code is used to a filled white circle quadrant by quadrant.
    if(secondLapsed != 0){
        
        float arcDegree;
        
        if(totalSeconds != 0){
            arcDegree = round(360/totalSeconds);
        }
        
        float startingDegree = 0;
        float endingDegree = 0;
        
        float radius = round(hole.width/2);
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        
        endingDegree = arcDegree * secondLapsed;
        if(startingDegree != endingDegree){
            CGContextMoveToPoint(context, destinationHoleCenter.x, destinationHoleCenter.y);
            CGContextAddArc(context, destinationHoleCenter.x, destinationHoleCenter.y, radius, startingDegree * M_PI/180.0, endingDegree * M_PI/180.0, 0);
            CGContextClosePath(context);
            CGContextFillPath(context);
        }
    }
}


@end
