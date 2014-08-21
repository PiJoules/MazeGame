//
//  MazeCell.m
//  Maze Run
//
//  Created by Leonard Chan on 8/21/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import "MazeCell.h"

@implementation MazeCell

@synthesize visited;
@synthesize walls;
@synthesize x;
@synthesize y;

- (id)init{
    self = [super init];
    
    visited = false;
    walls = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) [walls addObject:[NSNumber numberWithBool:true]];
    
    return self;
}

- (id)initWithX:(int)initX Y:(int)initY{
    self = [super init];
    
    visited = false;
    walls = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) [walls addObject:[NSNumber numberWithBool:true]];
    
    x = initX;
    y = initY;
    
    return self;
}

@end
