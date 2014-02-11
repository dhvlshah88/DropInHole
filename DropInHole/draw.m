//
//  draw.m
//  coregraphics
//
//  Created by vijay mysore on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "draw.h"

@implementation draw
@synthesize x,y,width,height,pcolor,fcolor,speed,linewidth,isGradient;
UIColor *startColor,*endColor;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        x=0;
        y=0;
        width=frame.size.width;
        height=frame.size.height;    
    
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
           
CGContextRef context = UIGraphicsGetCurrentContext();
    switch (fcolor) {
        case 0:
            [[UIColor redColor] setFill];
            endColor=[UIColor redColor];
          break;
        case 1:
            [[UIColor greenColor] setFill];
             endColor=[UIColor greenColor];
            break;
        case 2:
            [[UIColor blueColor] setFill];
             endColor=[UIColor blueColor];
            break;
        case 3:
            [[UIColor grayColor] setFill];
             endColor=[UIColor grayColor];
            break;
        case 4:
            [[UIColor brownColor] setFill];
             endColor=[UIColor brownColor];
            break;
               
        default:
            break;
    }
    switch (pcolor) {
        case 0:
            [[UIColor redColor] setStroke];
             startColor=[UIColor redColor];
            break;
        case 1:
            [[UIColor greenColor] setStroke];
             startColor=[UIColor greenColor];
            break;
        case 2:
            [[UIColor blueColor] setStroke];
             startColor=[UIColor blueColor];
            break;
        case 3:
            [[UIColor grayColor] setStroke];
             startColor=[UIColor grayColor];
            break;
        case 4:
            [[UIColor brownColor] setStroke];
             startColor=[UIColor brownColor];
            break;
            
        default:
            break;
    }
    if(isGradient){
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGColorRef xcolor=startColor.CGColor;
    CGColorRef ycolor=endColor.CGColor;
    CGColorRef colorRefs[2]={xcolor,ycolor};
    CFArrayRef colors = CFArrayCreate(NULL, (const void **)colorRefs, 2, NULL); 
    myColorspace= CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColors (myColorspace,(CFArrayRef) colors,locations);  
    CGPoint myStartPoint, myEndPoint;
    myStartPoint.x = x;
    myStartPoint.y = y;
    myEndPoint.x = x+width;
    myEndPoint.y = y+height;
    
    CGContextDrawLinearGradient (context, myGradient, myStartPoint, myEndPoint, 0);    
    }
    else{
    CGContextSetLineWidth(context, linewidth);
    CGContextSetShadow(context, CGSizeMake(-5, -5), 5);    
    CGRect arect={x+5,y+5,width-5,height-5};
    CGContextAddRect(context,arect);	
    CGContextDrawPath(context, kCGPathFillStroke);
    }
}




@end
