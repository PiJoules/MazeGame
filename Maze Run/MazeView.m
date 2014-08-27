//
//  MyView.m
//  Maze Run
//
//  Created by Leonard Chan on 8/10/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import "MazeView.h"

@implementation MazeView{
    float w,h;
    float rw; // row width
    int rcount; // rows
    int ccount; // cols
    int lineWidth;
    
    CGPoint point;
}

@synthesize hwalls;
@synthesize vwalls;

- (id)initWithFrame:(CGRect)frame startingPoint:(CGPoint)startingPoint rowCount:(int)rows colCount:(int)cols horizontalWalls:(NSMutableArray*)horizontalwalls verticalWalls:(NSMutableArray*)verticalwalls{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    w = [UIScreen mainScreen].bounds.size.width;
    h = [UIScreen mainScreen].bounds.size.height;
    
    rcount = rows;
    ccount = cols;
    rw = w/rcount;
    lineWidth = 2;
    
    hwalls = horizontalwalls;
    vwalls = verticalwalls;
    
    point = startingPoint;
    
    return self;
}

- (void)setNewRows:(int)rows andCols:(int)cols{
    rcount = rows;
    ccount = cols;
    rw = w/rcount;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef contextref = UIGraphicsGetCurrentContext(); // get current context
    CGContextSetLineWidth(contextref, 1); // set line width
    
    // draw blue box
    CGRect r = CGRectMake(rw*point.x, rw*point.y, rw, rw);
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

- (CGPoint)getCurrentPos{
    return point;
}
- (void)setCurrentPos:(CGPoint)nextPoint{
    point = nextPoint;
}

// movements
/*- (BOOL)moveUp{
    if (![hwalls[(int)point.y][(int)point.x] boolValue]){
        //NSLog(@"MazeView: can move up");
        point.y--;
        return true;
    }
    else {
        //NSLog(@"MazeView: can't move up");
        return false;
    }
}

- (BOOL)moveDown{
    if (![hwalls[(int)point.y+1][(int)point.x] boolValue]){
        //NSLog(@"MazeView: can move down");
        point.y++;
        return true;
    }
    else {
        //NSLog(@"MazeView: can't move down");
        return false;
    }
}

- (BOOL)moveLeft{
    if (![vwalls[(int)point.y][(int)point.x] boolValue]){
        //NSLog(@"MazeView: can move left");
        point.x--;
        return true;
    }
    else {
        //NSLog(@"MazeView: can't move left");
        return false;
    }
}

- (BOOL)moveRight{
    if (![vwalls[(int)point.y][(int)point.x+1] boolValue]){
        //NSLog(@"MazeView: can move right");
        point.x++;
        return true;
    }
    else {
        //NSLog(@"MazeView: can't move right");
        return false;
    }
}*/

@end
