//
//  levelFiveView.m
//  DropInHole
//
//  Created by Dhaval Shah on 02/06/2012.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import "levelFiveView.h"

@implementation levelFiveView{
    CGContextRef context;
}


@synthesize upperMovingBlock, lowerMovingBlock, screenBounds, hole, startingCoordinates, 
borderLineWidth, shadowOffset, destinationHoleCoordinates, 
innerBoundary, arrayOfUpperMovingBlocks,arrayOfLowerMovingBlocks, destinationHole,
shadowOffsetForDestHole, destinationHoleCenter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    
    upperMovingBlock = CGSizeMake(20.0, 295.0);
    
    lowerMovingBlock = CGSizeMake(20.0, -115.0);
    
    hole = CGSizeMake(30.0, 30.0);
    
    borderLineWidth = 0.5;
    
    shadowOffsetForDestHole = CGSizeMake(0, 0);
    
    destinationHoleCoordinates = CGPointMake(267, 420);
    
    blockStartingCoordinates = CGPointMake(60, 15);
    
    arrayOfUpperMovingBlocks = [[NSMutableArray alloc] initWithCapacity:4];
    [arrayOfUpperMovingBlocks addObject:[NSValue valueWithCGRect:CGRectMake(blockStartingCoordinates.x, blockStartingCoordinates.y, upperMovingBlock.width, upperMovingBlock.height)]];
    [arrayOfUpperMovingBlocks addObject:[NSValue valueWithCGRect:CGRectMake(2*blockStartingCoordinates.x, blockStartingCoordinates.y, lowerMovingBlock.width, ((-1) *lowerMovingBlock.height) + 10)]];
    [arrayOfUpperMovingBlocks addObject:[NSValue valueWithCGRect:CGRectMake(3*blockStartingCoordinates.x, blockStartingCoordinates.y, upperMovingBlock.width, upperMovingBlock.height + 10)]];
    [arrayOfUpperMovingBlocks addObject:[NSValue valueWithCGRect:CGRectMake(4*blockStartingCoordinates.x, blockStartingCoordinates.y, upperMovingBlock.width, (-1) *lowerMovingBlock.height)]];
    
    CGFloat lbStartYCoord = screenBounds.height - startingCoordinates.y;
    arrayOfLowerMovingBlocks = [[NSMutableArray alloc] initWithCapacity:4];
    [arrayOfLowerMovingBlocks addObject:[NSValue valueWithCGRect:CGRectMake(blockStartingCoordinates.x, lbStartYCoord, lowerMovingBlock.width, lowerMovingBlock.height)]];
    [arrayOfLowerMovingBlocks addObject:[NSValue valueWithCGRect:CGRectMake(2*blockStartingCoordinates.x, lbStartYCoord, lowerMovingBlock.width, (-1) * (upperMovingBlock.height + 10))]];
    [arrayOfLowerMovingBlocks addObject:[NSValue valueWithCGRect:CGRectMake(3*blockStartingCoordinates.x, lbStartYCoord, lowerMovingBlock.width, lowerMovingBlock.height - 10)]];
    [arrayOfLowerMovingBlocks addObject:[NSValue valueWithCGRect:CGRectMake(4*blockStartingCoordinates.x, lbStartYCoord, lowerMovingBlock.width, (-1) * upperMovingBlock.height)]];
    
}

// This method draws all the elements of level five view.
- (void)drawRect:(CGRect)rect
{
    //Set up the current graphics context in order to draw.   
    context = UIGraphicsGetCurrentContext();
    
    //Below given code is used to draw thick boundary to fill space between screen boundary and inner boundary.
    CGContextSetLineWidth(context, 30);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor brownColor].CGColor);
    CGRect boundary = CGRectMake(0, 0, screenBounds.width, screenBounds.height);
    CGContextAddRect(context, boundary);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //Below given code is used to draw the inner boundary inside the context.
    CGContextSetLineWidth(context, borderLineWidth);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextSetStrokeColorWithColor (context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
    //Below give code is used to draw blocks, set shadow around them and soft out the graphics. 
    CGContextSaveGState(context);
    CGContextSetShadow (context, shadowOffset, 8);
    
    for(int i=0; i<arrayOfUpperMovingBlocks.count; i++){
        CGContextAddRect(context, [[arrayOfUpperMovingBlocks objectAtIndex:i] CGRectValue]);
        CGContextAddRect(context, [[arrayOfLowerMovingBlocks objectAtIndex:i] CGRectValue]);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
    
    //Below given code is used to draw destination hole, shadow around it. 
    destinationHole = CGRectMake(destinationHoleCoordinates.x, destinationHoleCoordinates.y, hole.width, hole.height);
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0].CGColor);
    CGContextAddEllipseInRect(context, destinationHole);
    CGContextDrawPath(context, kCGPathFill);
    
    //CGContextRestoreGState(context);
      
   /* 
    shapeLayer = [CAShapeLayer layer];
	
    shapeLayer.path = firstUpperBlockPath;
    
	UIColor *fillColor = [UIColor colorWithHue:0.584 saturation:0.8 brightness:0.9 alpha:1.0];
	
	shapeLayer.fillColor = fillColor.CGColor; 
	
	UIColor *strokeColor = [UIColor colorWithHue:0.557 saturation:0.55 brightness:0.96 alpha:1.0];
	
	shapeLayer.strokeColor = strokeColor.CGColor;
	
	shapeLayer.lineWidth = 0.5;
	
	shapeLayer.fillRule = kCAFillRuleNonZero;
	
	[rootLayer addSublayer:shapeLayer];
	
//    SEL selector = @selector(startAnimationFrom:To:);
//    NSMethodSignature *signature = [[levelFiveView class] instanceMethodSignatureForSelector:selector];
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
//    [invocation setSelector:selector];
//    [invocation setTarget:self];
//    [invocation setArgument:CGPathCreateMutableCopy(firstUpperBlockPath) atIndex:2];
//    [invocation setArgument:CGPathCreateMutableCopy(firstUpperBlockPathLimit) atIndex:3];
    
	[self performSelector:@selector(startAnimationFrom:To:) withObject:nil afterDelay:1.0];
    
    shapeLayer1 = [CAShapeLayer layer];
	
    shapeLayer1.path = firstLowerBlockPath;
    
	fillColor = [UIColor colorWithHue:0.584 saturation:0.8 brightness:0.9 alpha:1.0];
	
	shapeLayer1.fillColor = fillColor.CGColor; 
	
	strokeColor = [UIColor colorWithHue:0.557 saturation:0.55 brightness:0.96 alpha:1.0];
	
	shapeLayer1.strokeColor = strokeColor.CGColor;
	
	shapeLayer1.lineWidth = 0.5;
	
	shapeLayer1.fillRule = kCAFillRuleNonZero;
	
	[shapeLayer addSublayer:shapeLayer1];
	
//    [invocation setArgument:CGPathCreateMutableCopy(firstLowerBlockPath) atIndex:2];
//    [invocation setArgument:CGPathCreateMutableCopy(firstLowerBlockPathLimit) atIndex:3];

	[self performSelector:@selector(startAnimation1From:To:) withObject:nil afterDelay:1.0];
}

-(void)startAnimationFrom:(CGMutablePathRef *)fromValue To:(CGMutablePathRef *)toValue
{	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
	
	animation.duration = 2.0;
	
	animation.repeatCount = HUGE_VALF;
	
	animation.autoreverses = YES;
	
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    animation.fromValue = (__bridge_transfer id) firstUpperBlockPath;	
    animation.toValue = (__bridge_transfer id) firstUpperBlockPathLimit;
	
	[shapeLayer addAnimation:animation forKey:@"animatePath"];
}

-(void)startAnimation1From:(CGMutablePathRef *)fromValue To:(CGMutablePathRef *)toValue
{	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
	
	animation.duration = 2.0;
	
	animation.repeatCount = HUGE_VALF;
	
	animation.autoreverses = YES;
	
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animation.fromValue = (__bridge_transfer id) firstLowerBlockPath;	
    animation.toValue = (__bridge_transfer id) firstLowerBlockPathLimit;
	
	[shapeLayer addAnimation:animation forKey:@"animatePath"]; */
}

@end
