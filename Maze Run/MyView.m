//
//  MyView.m
//  Maze Run
//
//  Created by Leonard Chan on 8/10/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import "MyView.h"

@implementation MyView{
    CGPoint center;
    float w,h;
    float dx,dy;
    float rad;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    w = [UIScreen mainScreen].bounds.size.width;
    h = [UIScreen mainScreen].bounds.size.height;
    dx = 1;
    dy = h/w;
    rad = 40;
    center = CGPointMake(-rad, -rad);
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    center.x += dx;
    center.y += dy;
    if (center.x > w-rad && center.y > h-rad){
        center.x = -rad;
        center.y = -rad;
    }
    
    CGContextRef contextref = UIGraphicsGetCurrentContext(); // get current context
    CGContextSetLineWidth(contextref, 2); // set line width
    CGContextSetRGBFillColor(contextref, 0, 0, 1, 1); // fill the object blue
    CGContextSetRGBStrokeColor(contextref, 0, 0, 1, 1); // set line stroke blue also
    CGRect circlePoint = CGRectMake(center.x, center.y, 2*rad, 2*rad); // create the circle
    CGContextFillEllipseInRect(contextref, circlePoint); // paint the rectangle on the canvas as an ellispe
    
    if (center.x < 0 && center.y < 0){
        CGRect circle2 = CGRectMake(center.x+w, center.y+h, 2*rad, 2*rad);
        CGContextFillEllipseInRect(contextref, circle2);
    }
    else if (center.x > w-2*rad && center.y > h-2*rad){
        CGRect circle2 = CGRectMake(center.x-w, center.y-h, 2*rad, 2*rad);
        CGContextFillEllipseInRect(contextref, circle2);
    }
}

@end
