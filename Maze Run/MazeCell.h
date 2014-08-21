//
//  MazeCell.h
//  Maze Run
//
//  Created by Leonard Chan on 8/21/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MazeCell : NSObject

- (id)initWithX:(int)initX Y:(int)initY;

@property BOOL visited;

// boolean array of walls [left top right bottom]
// true if up; false if down
@property (nonatomic, retain) NSMutableArray *walls;

@property int x;
@property int y;


@end
