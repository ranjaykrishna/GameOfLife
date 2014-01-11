//
//  MyScene.h
//  GameOfLife
//

//  Copyright (c) 2014 Ranjay Krishna. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

@property NSMutableArray * matrix;
@property CFTimeInterval lastTime;

-(void)initializeRandomly;
-(void)drawMatrix;

@end
