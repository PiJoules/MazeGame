//
//  TestView.m
//  Maze Run
//
//  Created by Leonard Chan on 8/23/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import "TestView.h"

@implementation TestView{
    int lineWidth;
    float w;
    
    int dist;
    int INITDIST;
    
    NSMutableArray *leftHalls;
    NSMutableArray *rightHalls;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        lineWidth = 2;
        w = [UIScreen mainScreen].bounds.size.width;
        dist = 9;
        INITDIST = dist;
        
        leftHalls = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:4], [NSNumber numberWithInt:9], [NSNumber numberWithInt:5], nil];
        [leftHalls sortUsingComparator:^NSComparisonResult(NSNumber *n1, NSNumber *n2){
            return [n1 compare:n2];
        }];
        rightHalls = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:4], [NSNumber numberWithInt:9], nil];
        [rightHalls sortUsingComparator:^NSComparisonResult(NSNumber *n1, NSNumber *n2){
            return [n1 compare:n2];
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef contextref = UIGraphicsGetCurrentContext(); // get current context
    CGContextSetLineWidth(contextref, 1); // set line width
    
    CGContextSetRGBStrokeColor(contextref, 0, 0, 0, 1);
    
    UIBezierPath *p = [UIBezierPath bezierPath];
    
    // draw borders
    CGRect r = CGRectMake(0, 0, w, w);
    p = [UIBezierPath bezierPathWithRect:r];
    p.lineWidth = lineWidth;
    [p stroke];
    
    // draw end hall line
    float hallWidth = (w/2)/(dist+1);
    p = [UIBezierPath bezierPath];
    p.lineWidth = lineWidth;
    [p moveToPoint:CGPointMake([[leftHalls lastObject] intValue]*hallWidth, w-[[leftHalls lastObject] intValue]*hallWidth)];
    [p addLineToPoint:CGPointMake(w-[[leftHalls lastObject] intValue]*hallWidth, w-[[leftHalls lastObject] intValue]*hallWidth)];
    [p stroke];
    
    // draw lines to signify adjascent halls
    for (NSNumber *n in leftHalls){
        if (n.intValue < 0) continue;
        // horizontal lines
        p = [UIBezierPath bezierPath];
        [p moveToPoint:CGPointMake((n.intValue-1)*hallWidth, n.intValue*hallWidth)];
        [p addLineToPoint:CGPointMake(n.intValue*hallWidth, n.intValue*hallWidth)];
        p.lineWidth = lineWidth;
        [p stroke];
        p = [UIBezierPath bezierPath];
        [p moveToPoint:CGPointMake((n.intValue-1)*hallWidth, w-n.intValue*hallWidth)];
        [p addLineToPoint:CGPointMake(n.intValue*hallWidth, w-n.intValue*hallWidth)];
        p.lineWidth = lineWidth;
        [p stroke];
        // vertical lines
        p = [UIBezierPath bezierPath];
        p.lineWidth = lineWidth;
        [p moveToPoint:CGPointMake((n.intValue-1)*hallWidth, (n.intValue-1)*hallWidth)];
        [p addLineToPoint:CGPointMake((n.intValue-1)*hallWidth, w-(n.intValue-1)*hallWidth)];
        [p stroke];
        if (n.intValue != dist){
            p = [UIBezierPath bezierPath];
            p.lineWidth = lineWidth;
            [p moveToPoint:CGPointMake(n.intValue*hallWidth, n.intValue*hallWidth)];
            [p addLineToPoint:CGPointMake(n.intValue*hallWidth, w-n.intValue*hallWidth)];
            [p stroke];
        }
    }
    for (NSNumber *n in rightHalls){
        if (n.intValue < 0) continue;
        // horizontal lines
        p = [UIBezierPath bezierPath];
        [p moveToPoint:CGPointMake(w-(n.intValue-1)*hallWidth, n.intValue*hallWidth)];
        [p addLineToPoint:CGPointMake(w-n.intValue*hallWidth, n.intValue*hallWidth)];
        p.lineWidth = lineWidth;
        [p stroke];
        p = [UIBezierPath bezierPath];
        [p moveToPoint:CGPointMake(w-(n.intValue-1)*hallWidth, w-n.intValue*hallWidth)];
        [p addLineToPoint:CGPointMake(w-n.intValue*hallWidth, w-n.intValue*hallWidth)];
        p.lineWidth = lineWidth;
        [p stroke];
        // vertical lines
        p = [UIBezierPath bezierPath];
        p.lineWidth = lineWidth;
        [p moveToPoint:CGPointMake(w-(n.intValue-1)*hallWidth, (n.intValue-1)*hallWidth)];
        [p addLineToPoint:CGPointMake(w-(n.intValue-1)*hallWidth, w-(n.intValue-1)*hallWidth)];
        [p stroke];
        if (n.intValue != dist){
            p = [UIBezierPath bezierPath];
            p.lineWidth = lineWidth;
            [p moveToPoint:CGPointMake(w-n.intValue*hallWidth, w-n.intValue*hallWidth)];
            [p addLineToPoint:CGPointMake(w-n.intValue*hallWidth, n.intValue*hallWidth)];
            [p stroke];
        }
    }
    p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(dist*hallWidth, dist*hallWidth)];
    [p addLineToPoint:CGPointMake(w-dist*hallWidth, dist*hallWidth)];
    p.lineWidth = lineWidth;
    [p stroke];
    
    
    // draw diagnols
    // upper left
    p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(0, 0)];
    int start = [leftHalls[0] intValue]-1;
    [p addLineToPoint:CGPointMake(start*hallWidth, start*hallWidth)];
    p.lineWidth = lineWidth;
    [p stroke];
    for (int i = 1; i < leftHalls.count; i++){
        p = [UIBezierPath bezierPath];
        int next1 = [leftHalls[i-1] intValue];
        int next2 = [leftHalls[i] intValue]-1;
        [p moveToPoint:CGPointMake(next1*hallWidth, next1*hallWidth)];
        [p addLineToPoint:CGPointMake(next2*hallWidth, next2*hallWidth)];
        p.lineWidth = lineWidth;
        [p stroke];
    }
    p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake([[leftHalls lastObject] intValue]*hallWidth, [[leftHalls lastObject] intValue]*hallWidth)];
    [p addLineToPoint:CGPointMake(dist*hallWidth, dist*hallWidth)];
    p.lineWidth = lineWidth;
    [p stroke];
    
    // upper right
    p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(w, 0)];
    start = [rightHalls[0] intValue]-1;
    [p addLineToPoint:CGPointMake(w-start*hallWidth, start*hallWidth)];
    p.lineWidth = lineWidth;
    [p stroke];
    for (int i = 1; i < rightHalls.count; i++){
        p = [UIBezierPath bezierPath];
        int next1 = [rightHalls[i-1] intValue];
        int next2 = [rightHalls[i] intValue]-1;
        [p moveToPoint:CGPointMake(w-next1*hallWidth, next1*hallWidth)];
        [p addLineToPoint:CGPointMake(w-next2*hallWidth, next2*hallWidth)];
        p.lineWidth = lineWidth;
        [p stroke];
    }
    p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(w-[[rightHalls lastObject] intValue]*hallWidth, [[rightHalls lastObject] intValue]*hallWidth)];
    [p addLineToPoint:CGPointMake(w-dist*hallWidth, dist*hallWidth)];
    p.lineWidth = lineWidth;
    [p stroke];
    
    // lower left
    p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(0, w)];
    start = [leftHalls[0] intValue]-1;
    [p addLineToPoint:CGPointMake(start*hallWidth, w-start*hallWidth)];
    p.lineWidth = lineWidth;
    [p stroke];
    for (int i = 1; i < leftHalls.count; i++){
        p = [UIBezierPath bezierPath];
        int next1 = [leftHalls[i-1] intValue];
        int next2 = [leftHalls[i] intValue]-1;
        [p moveToPoint:CGPointMake(next1*hallWidth, w-next1*hallWidth)];
        [p addLineToPoint:CGPointMake(next2*hallWidth, w-next2*hallWidth)];
        p.lineWidth = lineWidth;
        [p stroke];
    }
    p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake([[leftHalls lastObject] intValue]*hallWidth, w-[[leftHalls lastObject] intValue]*hallWidth)];
    [p addLineToPoint:CGPointMake(dist*hallWidth, w-dist*hallWidth)];
    p.lineWidth = lineWidth;
    [p stroke];
    
    // lower right
    p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(w, w)];
    start = [rightHalls[0] intValue]-1;
    [p addLineToPoint:CGPointMake(w-start*hallWidth, w-start*hallWidth)];
    p.lineWidth = lineWidth;
    [p stroke];
    for (int i = 1; i < rightHalls.count; i++){
        p = [UIBezierPath bezierPath];
        int next1 = [rightHalls[i-1] intValue];
        int next2 = [rightHalls[i] intValue]-1;
        [p moveToPoint:CGPointMake(w-next1*hallWidth, w-next1*hallWidth)];
        [p addLineToPoint:CGPointMake(w-next2*hallWidth, w-next2*hallWidth)];
        p.lineWidth = lineWidth;
        [p stroke];
    }
    p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(w-[[rightHalls lastObject] intValue]*hallWidth, w-[[rightHalls lastObject] intValue]*hallWidth)];
    [p addLineToPoint:CGPointMake(w-dist*hallWidth, w-dist*hallWidth)];
    p.lineWidth = lineWidth;
    [p stroke];
}

- (void)moveUp{
    dist--;
    if (dist < 1){
        dist = 1;
        NSLog(@"TestView: can't move up");
    }
    else {
        for (int i = 0; i < leftHalls.count; i++){
            int val = [leftHalls[i] intValue]-1;
            [leftHalls replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:val]];
        }
        for (int i = 0; i < rightHalls.count; i++){
            int val = [rightHalls[i] intValue]-1;
            [rightHalls replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:val]];
        }
        NSLog(@"TestView: can move up");
    }
}
- (void)moveDown{
    dist++;
    if (dist > INITDIST){
        dist = INITDIST;
        NSLog(@"TestView: can't move back");
    }
    else {
        for (int i = 0; i < leftHalls.count; i++){
            int val = [leftHalls[i] intValue]+1;
            [leftHalls replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:val]];
        }
        for (int i = 0; i < rightHalls.count; i++){
            int val = [rightHalls[i] intValue]+1;
            [rightHalls replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:val]];
        }
        NSLog(@"TestView: can move back");
    }
}
- (BOOL)moveLeft{
    for (NSNumber *n in leftHalls){
        if ([n intValue] == 1){
            NSLog(@"TestView: can turn left");
            //[self reset];
            return true;
        }
    }
    NSLog(@"TestVIew: can't turn left");
    return false;
}
- (BOOL)moveRight{
    for (NSNumber *n in rightHalls){
        if ([n intValue] == 1){
            NSLog(@"TestView: can turn right");
            //[self reset];
            return true;
        }
    }
    NSLog(@"TestView: can't turn right");
    return false;
}

- (void)reset:(int)nextDist leftHalls:(NSArray*)nextLeftHalls rightHalls:(NSArray*)nextRightHalls{
    //dist = arc4random_uniform(7)+3; // 0-9
    dist = nextDist;
    INITDIST = dist;
    
    /*NSMutableArray *nextLeftHalls = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++){
        int val = arc4random_uniform(dist);
        if (arc4random_uniform(2) > 0){
            if (![nextLeftHalls containsObject:[NSNumber numberWithInt:val]]){
                [nextLeftHalls addObject:[NSNumber numberWithInt:val]];
            }
        }
    }
    [nextLeftHalls addObject:[NSNumber numberWithInt:dist]];
    [nextLeftHalls sortUsingComparator:^NSComparisonResult(NSNumber *n1, NSNumber *n2){
        return [n1 compare:n2];
    }];
    leftHalls = nextLeftHalls;*/
    leftHalls = [NSMutableArray arrayWithArray:nextLeftHalls];
    
    /*NSMutableArray *nextRightHalls = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++){
        int val = arc4random_uniform(dist);
        if (arc4random_uniform(2) > 0){
            if (![nextRightHalls containsObject:[NSNumber numberWithInt:val]]){
                [nextRightHalls addObject:[NSNumber numberWithInt:val]];
            }
        }
    }
    [nextRightHalls addObject:[NSNumber numberWithInt:dist]];
    [nextRightHalls sortUsingComparator:^NSComparisonResult(NSNumber *n1, NSNumber *n2){
        return [n1 compare:n2];
    }];
    rightHalls = nextRightHalls;*/
    rightHalls = [NSMutableArray arrayWithArray:nextRightHalls];
}

@end
