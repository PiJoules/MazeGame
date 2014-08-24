//
//  TestViewController.m
//  Maze Run
//
//  Created by Leonard Chan on 8/23/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import "TestViewController.h"
#import "TestView.h"
#import <mach/mach.h>

@interface TestViewController ()

@end

@implementation TestViewController{
    TestView *tv;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tv = [[TestView alloc] initWithFrame:self.view.frame];
    self.view = tv;
    
    float w = [UIScreen mainScreen].bounds.size.width;
    float h = [UIScreen mainScreen].bounds.size.height;
    
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
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(drawLoop) userInfo:nil repeats:true];
}

- (void)drawLoop{
    //[self report_memory];
    [self.view setNeedsDisplay];
}

- (void)swipeUp{
    [tv moveUp];
}
- (void)swipeDown{
    [tv moveDown];
}
- (void)swipeLeft{
    [tv moveLeft];
}
- (void)swipeRight{
    [tv moveRight];
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



@end
