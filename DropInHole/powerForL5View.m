//
//  powerView.m
//  DropInHole
//
//  Created by Dhaval Shah on 05/06/2012.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import "powerForL5View.h"

@implementation powerForL5View{
    CGContextRef context;
}

@synthesize  starRadius, starWidth, drawStars;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//this method set bool array value to YES to draw star initially.
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (nil != self)
    {
        drawStars = [[NSMutableArray alloc] initWithCapacity:2];
        
        for(int i = 0; i<2; i++){
            [drawStars addObject:[NSNumber numberWithBool:YES]];
        }
    }
    
    return self;
}

//This method draw shrink, double power and text on them.
- (void)drawRect:(CGRect)rect
{
    context = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = 100.0;
    CGFloat yCenter = 45.0;
    
    starWidth = 30.0;
    starRadius = round(starWidth / 2.0); // 144 degrees
    
    float flip = -1.0;
    double theta = 2.0 * M_PI * (2.0 / 5.0);
    
    
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
        
    
    if([[drawStars objectAtIndex:0] boolValue]){
        
        //shrinkPower = CGPathCreateMutable();
        CGContextSaveGState(context);
        
        CGContextMoveToPoint(context, xCenter, starRadius*flip+yCenter);
        
        for (NSUInteger k=1; k<5; k++) 
        {
            float x = starRadius * sin(k * theta);
            float y = starRadius * cos(k * theta);
            CGContextAddLineToPoint(context, x+xCenter, y*flip+yCenter);
        }
        
        CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetBlendMode(context, kCGBlendModeMultiply);
        CGContextRestoreGState(context);
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 2);
        CGContextSelectFont(context, "Helvetica", 17,  kCGEncodingMacRoman);
        CGContextShowTextAtPoint(context, 85, 50, "0.5x", strlen("0.5x"));
        CGContextSetTextDrawingMode(context, kCGTextFill);
    }   
    
    xCenter += 150;
    yCenter += 105;
    
    
    if([[drawStars objectAtIndex:1] boolValue]){
        
        //shrinkPower = CGPathCreateMutable();
        CGContextSaveGState(context);
        
        CGContextMoveToPoint(context, xCenter, starRadius*flip+yCenter);
        
        for (NSUInteger k=1; k<5; k++) 
        {
            float x = starRadius * sin(k * theta);
            float y = starRadius * cos(k * theta);
            CGContextAddLineToPoint(context, x+xCenter, y*flip+yCenter);
        }
        
        CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetBlendMode(context, kCGBlendModeMultiply);
        
        CGContextRestoreGState(context);

        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 2);
        CGContextSelectFont(context, "Helvetica", 17,  kCGEncodingMacRoman);
        CGContextShowTextAtPoint(context, 240, 153, "2x", strlen("2x"));
        CGContextSetTextDrawingMode(context, kCGTextFill);

    }        
    
   
    
        
    
}



@end
