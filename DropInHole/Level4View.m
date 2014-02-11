//
//  Level4View.m
//  DropInHole
//
//  Created by Kalpesh Marlecha on 5/31/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import "Level4View.h"

@implementation Level4View

@synthesize i;

//synthesize all at one shot...
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
		[self commonInitializer]; // to initialize all the variables
	}
	
	return self;
}

-(void) commonInitializer{
    
    // name of variables explain the functionality, these are suppose to be initialised once, called in initwith coder, just to make sure its being loaded
    screenBounds = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    startingCoordinates= CGPointMake(15.0, 15.0);
    blockSize = CGSizeMake(40.0, 30.0);
    hole = CGSizeMake(30.0, 30.0);
    borderLineWidth = 0.5;
    shadowOffset = CGSizeMake(7, 7);
    finishHoleCoordinates = CGPointMake(255, 425);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //Will contain array of rectangle objects
    if(i < 450){
    if(i < 225){
        i+=10;
        arrayOfBlocks = [[NSMutableArray alloc] initWithCapacity:4];
        [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(i, 100, blockSize.width, blockSize.height)]]; 
        [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(225-i, 200, blockSize.width, blockSize.height)]];
        [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(i, 300, blockSize.width, blockSize.height)]];
        [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(225-i, 400, blockSize.width, blockSize.height)]];
    }
        else if( i >= 225 && i < 450)
        {
        i+=10;
        arrayOfBlocks = [[NSMutableArray alloc] initWithCapacity:4];
        [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(450-i, 100, blockSize.width, blockSize.height)]]; 
        [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(i-255, 200, blockSize.width, blockSize.height)]];
        [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(450-i, 300, blockSize.width, blockSize.height)]];
        [arrayOfBlocks addObject:[NSValue valueWithCGRect:CGRectMake(i-255, 400, blockSize.width, blockSize.height)]];
        }
    }
    else i=0;

    CGContextRef context = UIGraphicsGetCurrentContext();
    
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
        CGContextAddEllipseInRect(context, [[arrayOfBlocks objectAtIndex:j] CGRectValue]);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
    
    destinationHoleCoordinates = CGRectMake(finishHoleCoordinates.x, finishHoleCoordinates.y, hole.width, hole.height);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    
    CGContextAddEllipseInRect(context, destinationHoleCoordinates);
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end