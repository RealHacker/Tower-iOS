//
//  Game.h
//  Towers
//
//  Created by 雷 王 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define GAMECOUNTPERFILE 5

@interface Game : NSObject

@property (nonatomic) int gridSize;
@property (nonatomic) int gameIndex;
@property (nonatomic, retain) NSString* difficulty;

@property (nonatomic, retain) NSArray* game;

@property (nonatomic, retain) NSArray* solution;

@property (nonatomic, retain) NSArray* topHint;
@property (nonatomic, retain) NSArray* bottomHint;
@property (nonatomic, retain) NSArray* leftHint;
@property (nonatomic, retain) NSArray* rightHint;


- (id) initGameWithSize: (int) size Difficulty:(NSString*) difficulty Index:(int) index;
- (id) initGameWithSize: (int) size Difficulty:(NSString*) difficulty;

- (int) getGameCellAtX: (int) x Y: (int)y;
- (int) getSolutionCellAtX: (int) x Y: (int) y;

- (int) getLeftAt: (int) index;
- (int) getRightAt: (int) index;
- (int) getTopAt: (int) index;
- (int) getBottomAt: (int) index;

@end
