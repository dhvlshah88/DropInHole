//
//  draw.h
//  coregraphics
//
//  Created by vijay mysore on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface draw : UIView{
    
    float x,y,width,height;
    
}
@property float x,y,width,height;
@property int pcolor,fcolor,speed,linewidth;
@property BOOL isGradient;


@end
