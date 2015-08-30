//
//  GameScores.h
//  Towers
//
//  Created by 雷 王 on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameScores : NSObject

@property (nonatomic, retain) NSMutableDictionary* scores;
@property (nonatomic, retain) NSArray* keys;


+ (GameScores*) sharedGameScores;
- (void) readScores;
- (void) writeScoreMinutes:(int) minute Seconds:(int)second ForDifficulty:(NSString *)difficulty grid:(int)grids;
- (NSArray*) readScoreForDifficulty: (NSString*) difficulty grid:(int)grids;
- (void) flushScores;

@end
