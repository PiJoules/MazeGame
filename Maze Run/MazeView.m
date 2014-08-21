//
//  MyView.m
//  Maze Run
//
//  Created by Leonard Chan on 8/10/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import "MazeView.h"

@implementation MazeView{
    CGPoint center;
    float w,h;
    float dx,dy;
    float rad;
    
    float rw;
    int rcount; // rows
    int ccount; // cols
    int lineWidth;
    
    NSMutableArray *hwalls; // horizontal
    NSMutableArray *vwalls; // vertical
}

- (id)initWithFrame:(CGRect)frame width:(int)width height:(int)height{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    w = [UIScreen mainScreen].bounds.size.width;
    h = [UIScreen mainScreen].bounds.size.height;
    dx = 1;
    dy = h/w;
    rad = 40;
    center = CGPointMake(-rad, -rad);
    
    rcount = width;
    ccount = height;
    rw = w/rcount;
    lineWidth = 4;
    
    hwalls = [[NSMutableArray alloc] init];
    for (int y = 0; y < rcount+1; y++){
        [hwalls addObject:[[NSMutableArray alloc] init]];
        for (int x = 0; x < ccount; x++){
            [hwalls[y] addObject:[NSNumber numberWithBool:true]];
        }
    }
    vwalls = [[NSMutableArray alloc] init];
    for (int y = 0; y < rcount; y++){
        [vwalls addObject:[[NSMutableArray alloc] init]];
        for (int x = 0; x < ccount+1; x++){
            [vwalls[y] addObject:[NSNumber numberWithBool:true]];
        }
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef contextref = UIGraphicsGetCurrentContext(); // get current context
    CGContextSetLineWidth(contextref, 1); // set line width
    
    center.x += dx;
    center.y += dy;
    if (center.x > w-rad && center.y > h-rad){
        center.x = -rad;
        center.y = -rad;
    }
    
    /*
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
    }*/
    
    // draw grid
    /*for (int y = 0; y < rcount; y++){
        for (int x = 0; x < rcount; x++){
            CGRect r = CGRectMake(x*rw, y*rw, rw, rw);
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:r];
            path.lineWidth = 4;
            [path stroke];
        }
    }*/
    
    // draw walls
    CGContextSetRGBStrokeColor(contextref, 0, 0, 0, 1);
    for (int y = 0; y < rcount; y++){
        for (int x = 0; x < ccount+1; x++){
            if (![vwalls[y][x] boolValue]) continue;
            CGRect r = CGRectMake(x*rw, y*rw, 0, rw);
            UIBezierPath *p = [UIBezierPath bezierPathWithRect:r];
            p.lineWidth = lineWidth;
            [p stroke];
        }
    }
    for (int y = 0; y < rcount+1; y++){
        for (int x = 0; x < ccount; x++){
            if (![hwalls[y][x] boolValue]) continue;
            CGRect r = CGRectMake(x*rw, y*rw, rw, 0);
            UIBezierPath *p = [UIBezierPath bezierPathWithRect:r];
            p.lineWidth = lineWidth;
            [p stroke];
        }
    }
    
    // draw corners
    /*CGContextSetRGBFillColor(contextref, 1, 0, 0, 1);
    for (int y = 0; y < rcount+1; y++){
        for (int x = 0; x < rcount+1; x++){
            CGRect r = CGRectMake(x*rw-lineWidth/2, y*rw-lineWidth/2, lineWidth, lineWidth);
            CGContextFillRect(contextref, r);
        }
    }*/
}

/*
 NOTES
 
 1. TREAT MAZE AS 2D ARRAY
    - 2D ARRAY OF CELLS
        - CELL PROPERTIES
            - VISITED/NOT VISITED
            - WALL POSITIONS (AS BOOL ARRAY; [LEFT TOP RIHGT BOTTOM])
            - CELL POSITION IN 2D ARRAY
 2. STACK OF CELLS (FOR BACKTRACKING)
 
 */

@end
