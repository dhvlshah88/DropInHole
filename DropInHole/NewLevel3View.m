//
//  NewLevelKalpesh.m
//  DropInHole-LevelTest
//
//  Created by Kalpesh Marlecha on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewLevel3View.h"

@implementation NewLevel3View

static int i;

@synthesize blockSize, screenBounds, hole, startingCoordinates, borderLineWidth, shadowOffset, finishHoleCoordinates, innerBoundary, arrayOfBlocks, destinationHoleCoordinates;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (nil != self)
	{
		[self commonInitializer];
	}
	
	return self;
}


// To initialize the variables, called in initwith coder
-(void) commonInitializer{
    
    NSLog(@"In Initializer");
    
    screenBounds = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    startingCoordinates= CGPointMake(15.0, 15.0);
    blockSize = CGSizeMake(110.0, 40.0);
    hole = CGSizeMake(30.0, 30.0);
    borderLineWidth = 0.5;
    shadowOffset = CGSizeMake(7, 7);
    finishHoleCoordinates = CGPointMake(255, 425);
    i = 0;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"In Draw Rect");
    
    if(i<300)
        i+=10;
    else 
        i = 0;
    
    //Will contain array of rectangle objects
    arrayOfBlocks = [[NSMutableArray alloc] initWithCapacity:3];
    [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(225, 265-i, 40, 40)]]; //small object in middle to increase score
    [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(200, 160-i, blockSize.width, blockSize.height)]];
    [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(200, 365-i, blockSize.width, blockSize.height)]];
    [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(100, (i), 10, blockSize.height)]];
    // side object just to make a obstacle
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextRef anotherContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, borderLineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    innerBoundary = CGRectMake(startingCoordinates.x, startingCoordinates.y, screenBounds.width - (2 *startingCoordinates.x), screenBounds.height - (2 * startingCoordinates.y));
    CGContextAddRect(context, innerBoundary); // will draw the rectangle in screen
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSaveGState(context);
    CGContextSetShadow (context, shadowOffset, 8);
    
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
    
    for(int j=0; j<arrayOfBlocks.count; j++){
        
        if(j==0)
        {
            CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            CGContextAddRect(anotherContext, [[arrayOfBlocks objectAtIndex:0] CGRectValue]);
            CGContextDrawPath(context, kCGPathFillStroke);
        }else
        {
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            CGContextAddEllipseInRect(context, [[arrayOfBlocks objectAtIndex:j] CGRectValue]);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    
    CGContextRestoreGState(context);
    
    destinationHoleCoordinates = CGRectMake(finishHoleCoordinates.x, finishHoleCoordinates.y, hole.width, hole.height);
    
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextAddEllipseInRect(context, destinationHoleCoordinates);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end