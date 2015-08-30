//
//  GameState.h
//  Towers
//
//  Created by 雷 王 on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HASGAME @"hasUnfinishedGame"
#define GRIDSIZE @"gridSize"
#define GAMELEVEL @"gameLevel"
#define INDEXINFILE @"indexInFile"
#define MINUTES @"minutes"
#define SECONDS @"seconds"
#define MATRIX @"matrix"
#define SCRATCH @"scratch"

@interface GameState : NSObject

@property BOOL hasUnfinishedGame;

@property int gameGridSize;
@property (nonatomic, retain) NSString* gameLevel;
@property int indexInFile;

@property int timerMinutes;
@property int timerSeconds;

@property (nonatomic, retain) NSMutableArray* matrix;
@property (nonatomic, retain) NSMutableArray* scratch;

- (void) loadFromDisk;
- (void) saveToDisk;

+ (GameState*) sharedState;

@end
