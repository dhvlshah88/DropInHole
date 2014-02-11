//
//  powerView.h
//  DropInHole
//
//  Created by Dhaval Shah on 05/06/2012.
//  Copyright (c) 2012 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface powerForL5View : UIView{
    CGSize shadowOffset;
}

//This ivars is used to store radius and width of star.
@property double starRadius, starWidth;

//This ivars is used to store bool value in order to draw star.
@property (strong,nonatomic) NSMutableArray *drawStars;

@end