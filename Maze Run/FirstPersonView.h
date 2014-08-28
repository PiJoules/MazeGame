//
//  TestView.h
//  Maze Run
//
//  Created by Leonard Chan on 8/23/14.
//  Copyright (c) 2014 Leonard Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstPersonView : UIView

- (void)moveUp;
- (void)moveDown;
- (BOOL)moveLeft;
- (BOOL)moveRight;
- (BOOL)canMoveForward;
- (BOOL)canMoveBack;
- (BOOL)canTurnLeft;
- (BOOL)canTurnRight;

- (void)resetDist:(int)nextDist leftHalls:(NSArray*)nextLeftHalls rightHalls:(NSArray*)nextRightHalls;

@end
