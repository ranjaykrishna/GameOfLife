//
//  MyScene.m
//  GameOfLife
//
//  Created by Ranjay Krishna on 1/8/14.
//  Copyright (c) 2014 Ranjay Krishna. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

@synthesize matrix;
@synthesize lastTime;

static int const numCols = 70;
static int const numRows = 87;
static CGFloat const imageSize = 50.0;
static CGFloat const pixelSize = 5.0;
static CGFloat const pixelScale = pixelSize/imageSize;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithWhite:1.0 alpha:1.0];
        self.matrix = [[NSMutableArray alloc] initWithCapacity:numCols];
        for (int i = 0; i < numCols; i++) {
            self.matrix[i] = [[NSMutableArray alloc] initWithCapacity:numRows];
        }
        [self initializeRandomly];
        [self drawMatrix];
    }
    return self;
}

-(void)drawMatrix {
    for (int i = 0; i < numCols; i++) {
        for (int j = 0; j < numRows; j++) {
            NSNumber * value = matrix[i][j];
            if (value.intValue == 1) {
                SKSpriteNode *square = [SKSpriteNode spriteNodeWithImageNamed:@"blackSquare.png"];
                square.position = CGPointMake(i*pixelSize + pixelSize/2, j*pixelSize + pixelSize/2);
                square.xScale = pixelScale;
                square.yScale = pixelScale;
                [self addChild: square];
            }
        }
    }
}

-(void)initializeRandomly {
    for (int i = 0; i < numCols; i++) {
        for (int j = 0; j < numRows; j++) {
            NSInteger randomNumber = arc4random() % 2;
            self.matrix[i][j] = [NSNumber numberWithInteger:randomNumber];
        }
    }
}

-(int)countNumberofNeighborsAtCol:(int) i andRow:(int) j {
    NSNumber* val1 = self.matrix[(i+1)%numCols][(j+1)%numRows];
    NSNumber* val2 = self.matrix[(i+1)%numCols][(j)%numRows];
    NSNumber* val3 = self.matrix[(i+1)%numCols][(j-1+numRows)%numRows];
    NSNumber* val4 = self.matrix[(i)%numCols][(j-1+numRows)%numRows];
    NSNumber* val5 = self.matrix[(i-1+numCols)%numCols][(j-1+numRows)%numRows];
    NSNumber* val6 = self.matrix[(i-1+numCols)%numCols][(j)%numRows];
    NSNumber* val7 = self.matrix[(i-1+numCols)%numCols][(j+1)%numRows];
    NSNumber* val8 = self.matrix[(i)%numCols][(j+1)%numRows];
    return val1.intValue + val2.intValue + val3.intValue + val4.intValue
        + val5.intValue + val6.intValue + val7.intValue + val8.intValue;
}

-(void)nextStep {
    NSMutableArray * tempMatrix = [[NSMutableArray alloc] initWithCapacity:numCols];
    for (int i = 0; i < numCols; i++) {
        tempMatrix[i] = [[NSMutableArray alloc] initWithCapacity:numRows];
    }
    for (int i = 0; i < numCols; i++) {
        for (int j = 0; j < numRows; j++) {
            int neighbors = [self countNumberofNeighborsAtCol:i andRow: j];
            NSNumber * value = self.matrix[i][j];
            if (value.intValue == 1) {
                if (neighbors < 2 || neighbors > 3) {
                    tempMatrix[i][j] = [NSNumber numberWithInteger:0];
                } else {
                    tempMatrix[i][j] = [NSNumber numberWithInteger:1];
                }
            }
            else if (value.intValue == 0 && neighbors == 3) {
                tempMatrix[i][j] = [NSNumber numberWithInteger:1];
            } else {
                tempMatrix[i][j] = [NSNumber numberWithInteger:0];
            }
        }
    }
    self.matrix = tempMatrix;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self initializeRandomly];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if (!lastTime) lastTime = currentTime;
    if (currentTime - lastTime >= 0.3) {
        lastTime = currentTime;
        [self removeAllChildren];
        [self nextStep];
        [self drawMatrix];
    }
}

@end
