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

#define LEFT 0
#define FORWARDS 1
#define RIGHT 2
#define BACKWARDS 3

@interface MazeViewController ()

@end

@implementation MazeViewController{
    float w;
    float h;
    
    NSMutableArray *MazeCells;
    int rows;
    int cols;
    
    int currentX;
    int currentY;
    int TDDirections[4]; // top down directions; [left up right down];
    
    NSMutableArray *leftHalls;
    NSMutableArray *rightHalls;
    
    BOOL CLOCKWISE;
}

@synthesize hwalls;
@synthesize vwalls;
@synthesize mv;
@synthesize tv;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    rows = 10;
    cols = 10;
    currentX = 0;
    currentY = 0;
    
    w = [UIScreen mainScreen].bounds.size.width;
    h = [UIScreen mainScreen].bounds.size.height;
    
    CLOCKWISE = true;
    
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
    
    // add views
    [self addControls];
    
    // generate random maze
    [self generateMazeFrom:MazeCells startingAtX:currentX Y:currentY];
    if ([hwalls[1][0] boolValue]){ // make right forward if wall beneath starting pos
        [self changeDirections:RIGHT];
    }
    else if ([vwalls[0][1] boolValue]){
        [self changeDirections:BACKWARDS];
    }
    
    // add subviews
    mv = [[MazeView alloc] initWithFrame:CGRectMake(0, 0, w, w) startingPoint:CGPointMake(currentX, currentY) rowCount:rows colCount:cols horizontalWalls:hwalls verticalWalls:vwalls];
    [self.view addSubview:mv];
    tv = [[TestView alloc] initWithFrame:CGRectMake(0, 0, w, w)];
    
    // start the draw loop
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(drawLoop) userInfo:nil repeats:true];
}

- (void)changeDirections:(int)nextDir{
    if (nextDir == LEFT){
        TDDirections[0] = FORWARDS;
        TDDirections[1] = RIGHT;
        TDDirections[2] = BACKWARDS;
        TDDirections[3] = LEFT;
    }
    else if (nextDir == FORWARDS){
        TDDirections[0] = LEFT;
        TDDirections[1] = FORWARDS;
        TDDirections[2] = RIGHT;
        TDDirections[3] = BACKWARDS;
    }
    else if (nextDir == RIGHT){
        TDDirections[0] = BACKWARDS;
        TDDirections[1] = LEFT;
        TDDirections[2] = FORWARDS;
        TDDirections[3] = RIGHT;
    }
    else if (nextDir == BACKWARDS){
        TDDirections[0] = RIGHT;
        TDDirections[1] = BACKWARDS;
        TDDirections[2] = LEFT;
        TDDirections[3] = FORWARDS;
    }
}

- (void)rotate:(BOOL)clockwise{
    if (TDDirections[0] == FORWARDS){
        if (clockwise) [self changeDirections:FORWARDS];
        else [self changeDirections:BACKWARDS];
    }
    else if (TDDirections[1] == FORWARDS){
        if (clockwise) [self changeDirections:RIGHT];
        else [self changeDirections:LEFT];
    }
    else if (TDDirections[2] == FORWARDS){
        if (clockwise) [self changeDirections:BACKWARDS];
        else [self changeDirections:FORWARDS];
    }
    else if (TDDirections[3] == FORWARDS){
        if (clockwise) [self changeDirections:LEFT];
        else [self changeDirections:RIGHT];
    }
}

- (void)swipeUp{
    if ([[self.view subviews] containsObject:mv]){
        if ([mv moveUp]){
            [self changeDirections:FORWARDS];
            [tv moveUp];
        }
    }
    [mv moveUp];
    [tv moveUp];
    [self checkWin];
}
- (void)swipeDown{
    [mv moveDown];
    [tv moveDown];
    [self checkWin];
}
- (void)swipeLeft{
    [mv moveLeft];
    if ([tv moveLeft]) [self rotate:!CLOCKWISE];;
    [self checkWin];
}
- (void)swipeRight{
    [mv moveRight];
    if ([tv moveRight]) [self rotate:CLOCKWISE];;
    [self checkWin];
}

- (void)switchView{
    if ([[self.view subviews] containsObject:tv]){
        [tv removeFromSuperview];
        [self.view addSubview:mv];
    }
    else{
        [mv removeFromSuperview];
        [self.view addSubview:tv];
    }
}

- (int)getDist{
    if (TDDirections[0] == FORWARDS){
        for (int x = mv.getCurrentPos.x; x >= 0; x--){
            if (![hwalls[(int)mv.getCurrentPos.y][x] boolValue])
            if ([vwalls[(int)mv.getCurrentPos.y][x] boolValue]) return mv.getCurrentPos.x-x;
        }
    }
    else if (TDDirections[1] == FORWARDS){
        for (int y = mv.getCurrentPos.y; y >= 0; y--){
            if ([hwalls[y][(int)mv.getCurrentPos.x] boolValue]) return mv.getCurrentPos.y-y;
        }
    }
    else if (TDDirections[2] == FORWARDS){
        for (int x = mv.getCurrentPos.x+1; x < cols+1; x++){
            if ([vwalls[(int)mv.getCurrentPos.y][x] boolValue]) return x-mv.getCurrentPos.x-1;
        }
    }
    else if (TDDirections[3] == FORWARDS){
        for (int y = mv.getCurrentPos.y+1; y < rows+1; y++){
            if ([hwalls[y][(int)mv.getCurrentPos.x] boolValue]) return y-mv.getCurrentPos.y-1;
        }
    }
    return 0;
}

/*- (NSArray*)getLeftHalls{
    NSMutableArray *leftHalls = [[NSMutableArray alloc] init];
    if (TDDirections[0] == FORWARDS){
        for (int x = mv.getCurrentPos.x; x >= 0; x--){
            if (![hwalls[(int)mv.getCurrentPos.y][x] boolValue]) leftHalls addObject:<#(id)#>
        }
    }
}*/

- (void)checkWin{
    CGPoint currentPos = [mv getCurrentPos];
    if (currentPos.x == cols-1 && currentPos.y == rows-1){
        NSLog(@"win");
        //[mv setNewRows:++rows andCols:++cols];
        //[self reset];
    }
    NSLog(@"%d",[self getDist]);
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
    [mv setNeedsDisplay];
    [tv setNeedsDisplay];
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

- (void)addControls{
    float w1 = 100;
    float h1 = 40;
    
    // add reset button
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    [b addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [b setTitle:@"Reset" forState:UIControlStateNormal];
    [b sizeToFit];
    b.backgroundColor = [UIColor colorWithRed:0.878 green:1 blue:1 alpha:1];
    b.frame = CGRectMake(0, (h-w)/2+w-h1-h1/2, w1, h1);
    b.layer.cornerRadius = 10;
    b.layer.borderWidth = 1;
    b.layer.borderColor = [UIColor blueColor].CGColor;
    [self.view addSubview:b];
    
    // add transition button
    UIButton *transition = [UIButton buttonWithType:UIButtonTypeSystem];
    [transition addTarget:self action:@selector(switchView) forControlEvents:UIControlEventTouchUpInside];
    [transition setTitle:@"Switch" forState:UIControlStateNormal];
    transition.backgroundColor = [UIColor colorWithRed:0.878 green:1 blue:1 alpha:1];
    transition.frame = CGRectMake(0, (h-w)/2+w-h1/2, w1, h1);
    transition.layer.cornerRadius = 10;
    transition.layer.borderWidth = 1;
    transition.layer.borderColor = [UIColor blueColor].CGColor;
    [self.view addSubview:transition];
    
    // add turn around button
    UIButton *rotate = [UIButton buttonWithType:UIButtonTypeSystem];
    [rotate setTitle:@"Turn Around" forState:UIControlStateNormal];
    rotate.backgroundColor = [UIColor colorWithRed:0.878 green:1 blue:1 alpha:1];
    rotate.frame = CGRectMake(0, (h-w)/2+w+h1/2, w1, h1);
    rotate.layer.cornerRadius = 10;
    rotate.layer.borderWidth = 1;
    rotate.layer.borderColor = [UIColor blueColor].CGColor;
    [self.view addSubview:rotate];
    
    // add directional buttons
    float bw = 70;
    float bh = 70;
    // right button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"Right" forState:UIControlStateNormal];
    [rightButton sizeToFit];
    rightButton.backgroundColor = [UIColor colorWithRed:0.878 green:1 blue:1 alpha:1];
    rightButton.frame = CGRectMake(w-bw, (h-w)/2+w-bh, bw, bh*2);
    rightButton.layer.cornerRadius = 10;
    rightButton.layer.borderWidth = 1;
    rightButton.layer.borderColor = [UIColor blueColor].CGColor;
    [self.view addSubview:rightButton];
    // top button
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [upButton addTarget:self action:@selector(swipeUp) forControlEvents:UIControlEventTouchUpInside];
    [upButton setTitle:@"Up" forState:UIControlStateNormal];
    upButton.backgroundColor = [UIColor colorWithRed:0.878 green:1 blue:1 alpha:1];
    upButton.frame = CGRectMake(w-bw-bw, (h-w)/2+w-bh, bw, bh);
    upButton.layer.cornerRadius = 10;
    upButton.layer.borderWidth = 1;
    upButton.layer.borderColor = [UIColor blueColor].CGColor;
    [self.view addSubview:upButton];
    // down button
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [downButton addTarget:self action:@selector(swipeDown) forControlEvents:UIControlEventTouchUpInside];
    [downButton setTitle:@"Down" forState:UIControlStateNormal];
    downButton.backgroundColor = [UIColor colorWithRed:0.878 green:1 blue:1 alpha:1];
    downButton.frame = CGRectMake(w-bw-bw, (h-w)/2+w, bw, bh);
    downButton.layer.cornerRadius = 10;
    downButton.layer.borderWidth = 1;
    downButton.layer.borderColor = [UIColor blueColor].CGColor;
    [self.view addSubview:downButton];
    // left button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"Left" forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor colorWithRed:0.878 green:1 blue:1 alpha:1];
    leftButton.frame = CGRectMake(w-bw*3, (h-w)/2+w-bh, bw, bh*2);
    leftButton.layer.cornerRadius = 10;
    leftButton.layer.borderWidth = 1;
    leftButton.layer.borderColor = [UIColor blueColor].CGColor;
    [self.view addSubview:leftButton];
    
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
}

@end
