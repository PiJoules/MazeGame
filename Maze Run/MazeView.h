//
//  MyView.h
//  Maze Run
//
//  Created by Leonard Chan on 8/10/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MazeView : UIView

- (id)initWithFrame:(CGRect)frame startingPoint:(CGPoint)startingPoint rowCount:(int)rows colCount:(int)cols horizontalWalls:(NSMutableArray*)horizontalwalls verticalWalls:(NSMutableArray*)verticalwalls;
- (void)setNewRows:(int)rows andCols:(int)cols;

/*- (BOOL)moveUp;
- (BOOL)moveDown;
- (BOOL)moveLeft;
- (BOOL)moveRight;*/
- (CGPoint)getCurrentPos;
- (void)setCurrentPos:(CGPoint)nextPoint;

@property NSMutableArray *hwalls; // horizontal
@property NSMutableArray *vwalls; // vertical

@end
