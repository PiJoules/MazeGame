//
//  MyView.h
//  Maze Run
//
//  Created by Leonard Chan on 8/10/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MazeView : UIView

- (id)initWithFrame:(CGRect)frame width:(int)width height:(int)height;
- (id)initWithFrame:(CGRect)frame rowCount:(int)rows colCount:(int)cols horizontalWalls:(NSMutableArray*)horizontalwalls verticalWalls:(NSMutableArray*)verticalwalls;

@property NSMutableArray *hwalls; // horizontal
@property NSMutableArray *vwalls; // vertical

@end
