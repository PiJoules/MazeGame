//
//  ViewController.m
//  Maze Run
//
//  Created by Leonard Chan on 8/10/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import "MazeViewController.h"
#import "MazeView.h"
#import "MazeCell.h"
#import <mach/mach.h>

@interface MazeViewController ()

@end

@implementation MazeViewController

@synthesize hwalls;
@synthesize vwalls;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"w:%f h:%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    
    int rows = 10;
    int cols = 10;
    MazeView *mv = [[MazeView alloc] initWithFrame:self.view.frame width:rows height:cols];
    
    [self setView:mv];
    
    // 2d arrays of booleans signifying which horizontal/vertical walls should be up
    hwalls = [[NSMutableArray alloc] init];
    vwalls = [[NSMutableArray alloc] init];
    
    // fill mazeCells and walls array
    NSMutableArray *mazeCells = [[NSMutableArray alloc] init];
    for (int y = 0; y < rows+1; y++){
        if (y < rows){
            [mazeCells addObject:[[NSMutableArray alloc] init]];
            [vwalls addObject:[[NSMutableArray alloc] init]];
        }
        [hwalls addObject:[[NSMutableArray alloc] init]];
        for (int x = 0; x < cols+1; x++){
            if (x < cols && y < rows) [mazeCells[y] addObject:[[MazeCell alloc] initWithX:x Y:y]];
            if (y < rows) [vwalls[y] addObject:[NSNumber numberWithBool:true]];
            if (x < cols) [hwalls[y] addObject:[NSNumber numberWithBool:true]];
        }
    }
    
    //[[mazeCells[0][7] walls] replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:false]];
    //[self generateMazeFrom:mazeCells startingAtX:0 Y:0];
    //NSLog(@"%@",[mazeCells[0][7] walls][2]);
    //NSLog(@"%hhd",[mazeCells[0][0] visited]);
    
    //MazeCell *temp = mazeCells[0][0];
    //[temp setVisited:true];
    //NSLog(@"%hhd",[mazeCells[0][0] visited]);
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(drawLoop) userInfo:nil repeats:true];
}

- (void)drawLoop{
    [self report_memory];
    [self.view setNeedsDisplay];
}

- (void)report_memory{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSNumber *num = [NSNumber numberWithUnsignedInt:info.resident_size];
        NSLog(@"Memory in use (in megabytes): %f", num.doubleValue/1000000);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// algorithm for generating the maze
- (void)generateMazeFrom:(NSMutableArray*)mazeCells startingAtX:(int)x Y:(int)y{
    
    // make initial cell the current cell and mark as visited
    MazeCell *currentCell = mazeCells[y][x];
    [currentCell setVisited:true];
    
    // keep track of the number of unvisited cells
    // subtract the initial cell since it starts as visited
    int unvisitedCellCount = [mazeCells count]*[mazeCells[0] count];
    unvisitedCellCount--;
    
    // stack of cells
    NSMutableArray *cellStack = [[NSMutableArray alloc] init];
    
    while (unvisitedCellCount > 0){
        NSMutableArray *neighbors = [self neighborsAtX:currentCell.x Y:currentCell.y inMaze:mazeCells];
        if ([neighbors count] > 0){
            MazeCell *neighbor = neighbors[arc4random_uniform([neighbors count])]; // choose neighbor
            [cellStack addObject:currentCell]; // add current cell to stack
            
            // remove the wall between the neighboring and current cell
            /*if (neighbor.x < currentCell.x) [walls[y] replaceObjectAtIndex:currentCell.x withObject:[NSNumber numberWithBool:false]];
            else if (neighbor.x > currentCell.x) [walls[y] replaceObjectAtIndex:currentCell.x+1 withObject:[NSNumber numberWithBool:false]];
            else if (neighbor.y < currentCell.y) [walls[y] replaceObjectAtIndex:currentCell.x withObject:[NSNumber numberWithBool:false]];
            else if (neighbor.y > currentCell.y) [walls[y] replaceObjectAtIndex:currentCell.x withObject:[NSNumber numberWithBool:false]];*/
            
            currentCell = neighbor; // make chosen neighbor the current cell
        }
    }
    
}

// get neighboring cells that have not been visited
// will return array of length zero if all neighbors were visited
- (NSMutableArray*)neighborsAtX:(int)x Y:(int)y inMaze:(NSMutableArray*)mazeCells{
    int w = [mazeCells[0] count];
    int h = [mazeCells count];
    NSMutableArray *neighbors = [[NSMutableArray alloc] init];
    if (x > 0){
        if (![mazeCells[y][x-1] visited]) [neighbors addObject:mazeCells[y][x-1]];
    }
    if (x < w-1){
        if (![mazeCells[y][x+1] visited]) [neighbors addObject:mazeCells[y][x+1]];
    }
    if (y > 0){
        if (![mazeCells[y-1][x] visited]) [neighbors addObject:mazeCells[y-1][x]];
    }
    if (y < h-1){
        if (![mazeCells[y+1][x] visited]) [neighbors addObject:mazeCells[y+1][x]];
    }
    return neighbors;
}

@end
