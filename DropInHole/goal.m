//
//  goal.m
//  coregraphics
//
//  Created by vijay mysore on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "goal.h"

@implementation goal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

     [[UIColor blueColor] setStroke];
    [[UIColor lightGrayColor] setFill];
    CGRect arect={285,420,30,30};
    CGContextAddEllipseInRect(context,arect);	
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
}


@end
