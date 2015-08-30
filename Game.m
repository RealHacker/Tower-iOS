//
//  Game.m
//  Towers
//
//  Created by 雷 王 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "GameState.h"

@implementation Game

#define GAMESKEY @"games"
#define GAMESIZE @"size"

@synthesize game = _game;
@synthesize solution = _solution;
@synthesize gridSize = _gridSize;
@synthesize topHint, bottomHint, leftHint, rightHint;
@synthesize gameIndex = _gameIndex;
@synthesize difficulty = _difficulty;

- (void) loadShortSegment: (NSString*) segment To: (int) side
{
    NSMutableArray* tempArray = [NSMutableArray array];
    
    for (int i = 0; i< self.gridSize; i++) {
        char c= [segment characterAtIndex:i];
        [tempArray addObject: [NSNumber numberWithInt:c-'0']];
    }
    switch (side) {
        case 1:
            self.topHint = tempArray;
            break;
        case 2:
            self.bottomHint = tempArray;
            break;
        case 3:
            self.leftHint = tempArray;
            break;
        case 4:
            self.rightHint = tempArray;
            break;
        default:
            break;
    }
}
- (void) loadLongSegment: (NSString*) segment To: (NSString*) which
{
    int cellCount = self.gridSize * self.gridSize;
    NSAssert([segment length]== cellCount, @"The cell count of game should be size squared");
    NSMutableArray* gameArray = [NSMutableArray array];
    
    for (int i = 0; i<cellCount; i++)
    {
        char c = [segment characterAtIndex:i];
        [gameArray addObject:[NSNumber numberWithInt:c-'0']];
    }
    if (which ==@"game") {
        self.game = gameArray;
    } else{
        self.solution = gameArray;
    }
}
- (id) initGameWithSize:(int)size Difficulty:(NSString *)difficulty Index:(int)index
{
    //The file name is in the format of Difficulty_Gridsize.plist
    if(self = [super init])
    {
        NSString* fileName = [NSString stringWithFormat:@"%@_%d.plist", difficulty, size];
        NSString *Path = [[NSBundle mainBundle] bundlePath];
        NSString *levelPath = [Path stringByAppendingPathComponent:fileName];
        NSDictionary* gameDict = [[NSDictionary alloc] initWithContentsOfFile:levelPath];
        
        NSNumber* number = [gameDict objectForKey:GAMESIZE];
        self.gridSize = [number intValue];
        NSAssert(self.gridSize >3 && self.gridSize <9, @"The grid size should be between 4 and 8");
        
        
        NSArray* games = [gameDict objectForKey:GAMESKEY];
    
        self.gameIndex = index;
        self.difficulty = difficulty;
        
        NSString* gameString = [games objectAtIndex:self.gameIndex];
        
        //parse the game string
        NSArray* segments = [gameString componentsSeparatedByString:@" "];
        NSAssert([segments count] == 6, @"The segment count should be 6");
        
        [self loadLongSegment:[segments objectAtIndex:0] To:@"game"];
        [self loadLongSegment:[segments objectAtIndex:1] To:@"solution"];
        
        [self loadShortSegment:[segments objectAtIndex:2] To:1];
        [self loadShortSegment:[segments objectAtIndex:3] To:2];                
        [self loadShortSegment:[segments objectAtIndex:4] To:3];
        [self loadShortSegment:[segments objectAtIndex:5] To:4];
    }
    return self;
}

- (id) initGameWithSize:(int)size Difficulty:(NSString *)difficulty
{
    int randomIndex = arc4random()%GAMECOUNTPERFILE;
    [GameState sharedState].hasUnfinishedGame = YES;
    [GameState sharedState].gameGridSize = size;
    [GameState sharedState].gameLevel = difficulty;
    [GameState sharedState].indexInFile = randomIndex;
    return [self initGameWithSize:size Difficulty:difficulty Index:randomIndex];
}

- (int) getGameCellAtX:(int)x Y:(int)y
{
    int index = y* self.gridSize + x;
    return [[self.game objectAtIndex:index] intValue];
}
- (int) getSolutionCellAtX:(int)x Y:(int)y
{
    int index = y* self.gridSize + x;
    return [[self.solution objectAtIndex:index] intValue];
}
- (int) getLeftAt:(int)index
{
    return [[self.leftHint objectAtIndex:index] intValue];
}
- (int) getRightAt:(int)index
{
    return [[self.rightHint objectAtIndex:index] intValue];
}
- (int) getTopAt:(int)index
{
    return [[self.topHint objectAtIndex:index] intValue];
}
-(int) getBottomAt:(int)index
{
    return [[self.bottomHint objectAtIndex:index] intValue];
}
@end
