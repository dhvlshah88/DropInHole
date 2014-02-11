//
//  drawRect.m
//  openview
//
//  Created by vijay mysore on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "drawRect.h"

@implementation drawRect


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
  //  CGFloat redColor[] = {100.0, 0.0, 0.0, 1.0};
    
    CGPoint origin = { 36.0, 109.0 };
    CGSize squareSize = { 238.0, 190.0 };
    CGRect aSquare = { origin, squareSize };
     [[UIColor blueColor] setStroke];
    //CGContextSetStrokeColorWithColor(context,);
                                     
    CGContextAddRect(context,aSquare);
    CGContextDrawPath(context, kCGPathStroke);
    
CGRect bsquare ={66,139,188,130 };
    [[UIColor grayColor] setStroke];
    CGContextAddRect(context,bsquare);
    CGContextDrawPath(context, kCGPathStroke);   
    
    CGRect csquare ={96,169,128,70 };
    [[UIColor redColor] setStroke];
    CGContextAddRect(context,csquare);
    CGContextDrawPath(context, kCGPathStroke);       
    
}
@end
