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
}

@synthesize hwalls;
@synthesize vwalls;

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
- (id)initWithFrame:(CGRect)frame rowCount:(int)rows colCount:(int)cols horizontalWalls:(NSMutableArray*)horizontalwalls verticalWalls:(NSMutableArray*)verticalwalls{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    w = [UIScreen mainScreen].bounds.size.width;
    h = [UIScreen mainScreen].bounds.size.height;
    dx = 1;
    dy = h/w;
    rad = 40;
    center = CGPointMake(-rad, -rad);
    
    rcount = rows;
    ccount = cols;
    rw = w/rcount;
    lineWidth = 4;
    
    hwalls = horizontalwalls;
    vwalls = verticalwalls;
    
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
    
    CGRect r = CGRectMake(0, 0, rw, rw);
    CGContextSetRGBFillColor(contextref, 0, 0, 1, 1);
    CGContextFillRect(contextref, r);
    r = CGRectMake(rw*(ccount-1), rw*(rcount-1), rw, rw);
    CGContextSetRGBFillColor(contextref, 1, 0, 0, 1);
    CGContextFillRect(contextref, r);
    
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
}

@end
