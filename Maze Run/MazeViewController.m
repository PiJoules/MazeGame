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

@implementation MazeViewController{
    NSMutableArray *MazeCells;
    int rows;
    int cols;
    
    int currentX;
    int currentY;
}

@synthesize hwalls;
@synthesize vwalls;
@synthesize mv;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    rows = 20;
    cols = 20;
    currentX = 0;
    currentY = 0;
    
    // 2d arrays of booleans signifying which horizontal/vertical walls should be up
    hwalls = [[NSMutableArray alloc] init];
    vwalls = [[NSMutableArray alloc] init];
    
    // fill mazeCells and walls array
    MazeCells = [[NSMutableArray alloc] init];
    for (int y = 0; y < rows+1; y++){
        if (y < rows){
            [MazeCells addObject:[[NSMutableArray alloc] init]];
            [vwalls addObject:[[NSMutableArray alloc] init]];
        }
        [hwalls addObject:[[NSMutableArray alloc] init]];
        for (int x = 0; x < cols+1; x++){
            if (x < cols && y < rows) [MazeCells[y] addObject:[[MazeCell alloc] initWithX:x Y:y]];
            if (y < rows) [vwalls[y] addObject:[NSNumber numberWithBool:true]];
            if (x < cols) [hwalls[y] addObject:[NSNumber numberWithBool:true]];
        }
    }
    
    [self generateMazeFrom:MazeCells startingAtX:currentX Y:currentY];
    
    mv = [[MazeView alloc] initWithFrame:self.view.frame startingPoint:CGPointMake(currentX, currentY) rowCount:rows colCount:cols horizontalWalls:hwalls verticalWalls:vwalls];
    [self setView:mv];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    [b addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [b setTitle:@"Reset" forState:UIControlStateNormal];
    float w = [UIScreen mainScreen].bounds.size.width;
    float h = [UIScreen mainScreen].bounds.size.height;
    [b sizeToFit];
    b.backgroundColor = [UIColor colorWithRed:0.878 green:1 blue:1 alpha:1];
    b.frame = CGRectMake(w/2-b.frame.size.width, (h-w)/2+w-b.frame.size.height, b.frame.size.width*2, b.frame.size.height*2);
    b.layer.cornerRadius = 10;
    b.layer.borderWidth = 1;
    b.layer.borderColor = [UIColor blueColor].CGColor;
    [self.view addSubview:b];
    
    // setup swipe recognizers
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
    up.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:up];
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
    down.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:down];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:left];
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    
    // start the draw loop
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(drawLoop) userInfo:nil repeats:true];
}

- (void)swipeUp{
    NSLog(@"up");
    [mv moveUp];
}
- (void)swipeDown{
    NSLog(@"down");
    [mv moveDown];
}
- (void)swipeLeft{
    NSLog(@"left");
    [mv moveLeft];
}
- (void)swipeRight{
    NSLog(@"right");
    [mv moveRight];
}

- (void)reset{
    [mv setCurrentPos:CGPointMake(0, 0)];
    
    [MazeCells removeAllObjects];
    [vwalls removeAllObjects];
    [hwalls removeAllObjects];
    for (int y = 0; y < rows+1; y++){
        if (y < rows){
            [MazeCells addObject:[[NSMutableArray alloc] init]];
            [vwalls addObject:[[NSMutableArray alloc] init]];
        }
        [hwalls addObject:[[NSMutableArray alloc] init]];
        for (int x = 0; x < cols+1; x++){
            if (x < cols && y < rows) [MazeCells[y] addObject:[[MazeCell alloc] initWithX:x Y:y]];
            if (y < rows) [vwalls[y] addObject:[NSNumber numberWithBool:true]];
            if (x < cols) [hwalls[y] addObject:[NSNumber numberWithBool:true]];
        }
    }
    
    [self generateMazeFrom:MazeCells startingAtX:0 Y:0];
}

- (void)drawLoop{
    //[self report_memory];
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
            if (neighbor.x < currentCell.x){
                [vwalls[currentCell.y] replaceObjectAtIndex:currentCell.x withObject:[NSNumber numberWithBool:false]];
            }
            else if (neighbor.x > currentCell.x){
                [vwalls[currentCell.y] replaceObjectAtIndex:currentCell.x+1 withObject:[NSNumber numberWithBool:false]];
            }
            else if (neighbor.y < currentCell.y){
                [hwalls[currentCell.y] replaceObjectAtIndex:currentCell.x withObject:[NSNumber numberWithBool:false]];
            }
            else if (neighbor.y > currentCell.y){
                [hwalls[currentCell.y+1] replaceObjectAtIndex:currentCell.x withObject:[NSNumber numberWithBool:false]];
            }
            
            currentCell = neighbor; // make chosen neighbor the current cell
            [currentCell setVisited:true]; // mark it as visited
            unvisitedCellCount--;
        }
        else if ([cellStack count] > 0){
            currentCell = [cellStack lastObject]; // pop last cell in stack and make it current cell
            [cellStack removeLastObject];
        }
        else{
            // find random unvisited cell and make it current cell and mark it as visited
            BOOL dobreak = false;
            for (int y = 0; y < [mazeCells count] && !dobreak; y++){
                for (int x = 0; x < [mazeCells[y] count]; x++){
                    if (![mazeCells[y][x] visited]){
                        currentCell = mazeCells[y][x];
                        [currentCell setVisited:true];
                        unvisitedCellCount--;
                        dobreak = true; // break out of outer for-loop
                        break;
                    }
                }
            }
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
