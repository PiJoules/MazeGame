//
//  ViewController.h
//  Maze Run
//
//  Created by Leonard Chan on 8/10/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MazeView.h"

@interface MazeViewController : UIViewController

@property NSMutableArray *hwalls;
@property NSMutableArray *vwalls;
@property MazeView *mv;

@end
