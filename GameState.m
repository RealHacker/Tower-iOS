//
//  GameState.m
//  Towers
//
//  Created by 雷 王 on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"

@implementation GameState

@synthesize hasUnfinishedGame;
@synthesize gameGridSize;
@synthesize gameLevel;
@synthesize indexInFile;
@synthesize matrix;
@synthesize scratch;
@synthesize timerMinutes;
@synthesize timerSeconds;

+ (GameState *)sharedState
{
    static GameState* singleton = nil;
    
    if (singleton==nil) {
        singleton = [[GameState alloc] init];
        [singleton retain];
    }
    return singleton;
}

- (void)loadFromDisk
{

    NSNumber* boolNumber = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:HASGAME];
    if (!boolNumber) {
        self.hasUnfinishedGame = false;
    } else{
        self.hasUnfinishedGame = [boolNumber boolValue];
    }
    
    if (self.hasUnfinishedGame) {
    
    NSNumber* intNumber = (NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:GRIDSIZE];
    self.gameGridSize = [intNumber intValue];
    
    self.gameLevel = [[NSUserDefaults standardUserDefaults] objectForKey:GAMELEVEL];
    
    intNumber = (NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:INDEXINFILE];
    self.indexInFile = [intNumber intValue];
    
    intNumber = (NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:MINUTES];
    self.timerMinutes = [intNumber intValue];
    
    intNumber = (NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:SECONDS];
    self.timerSeconds = [intNumber intValue];
    
    NSArray* array1 = [[NSUserDefaults standardUserDefaults] objectForKey:MATRIX];
    self.matrix = [NSMutableArray arrayWithArray:array1];
    
    NSArray* array2 = [[NSUserDefaults standardUserDefaults] objectForKey:SCRATCH];
        NSLog(@"%@", [[[array2 objectAtIndex:0]objectAtIndex:0] class]);
    self.scratch = [NSMutableArray arrayWithArray:array2];
    }
    
    //self.hasUnfinishedGame = true;
}

- (void)saveToDisk
{
    NSNumber* boolNumber = [NSNumber numberWithBool:self.hasUnfinishedGame];
    [[NSUserDefaults standardUserDefaults] setObject:boolNumber forKey:HASGAME];
    
    if (self.hasUnfinishedGame) {

    NSNumber* intNumber = [NSNumber numberWithInt:self.gameGridSize];
    [[NSUserDefaults standardUserDefaults] setObject:intNumber forKey:GRIDSIZE];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.gameLevel forKey:GAMELEVEL];
    
    NSNumber* intNumber2 = [NSNumber numberWithInt:self.indexInFile];
    [[NSUserDefaults standardUserDefaults] setObject:intNumber2 forKey:INDEXINFILE];
    
    NSNumber* intNumberMinutes = [NSNumber numberWithInt:self.timerMinutes];
    [[NSUserDefaults standardUserDefaults] setObject:intNumberMinutes forKey:MINUTES];
    
    NSNumber* intNumberSeconds = [NSNumber numberWithInt:self.timerSeconds];
    [[NSUserDefaults standardUserDefaults] setObject:intNumberSeconds forKey:SECONDS];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.matrix forKey:MATRIX];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.scratch forKey:SCRATCH];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
@end
