//
//  levelTwoView.m
//  DropInHole
//
//  Created on 5/22/12.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import "levelTwoView.h"

@implementation levelTwoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect destinationHole;
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    //CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(7,7), 8);
    destinationHole =CGRectMake(138, 387, 30, 30);  
    
    [[UIColor grayColor] setFill];
    [[UIColor blackColor] setStroke]; 
    CGContextAddEllipseInRect(context, destinationHole); 
    
    CGContextDrawPath(context, kCGPathFillStroke); 
    
}



@end
