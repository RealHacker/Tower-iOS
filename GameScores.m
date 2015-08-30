//
//  GameScores.m
//  Towers
//
//  Created by 雷 王 on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameScores.h"

@implementation GameScores

@synthesize scores = _scores;
@synthesize keys = _keys;

+ (GameScores*) sharedGameScores
{
    static GameScores* shared = nil;
    
    if (!shared) {
        shared = [[GameScores alloc] init];
        [shared retain];
    }
    return shared;
}

- (void) readScores
{
    //if the file doesn't exist in Documents directiory, create it
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString* plistPath = [rootPath stringByAppendingPathComponent:@"Scores.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSMutableDictionary* temp = [NSMutableDictionary dictionary];
        //initially, all scores are 00:00
        for (NSString* key in self.keys){
            NSArray* nilscore = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0],nil];
            [temp setObject:nilscore forKey:key];
        }
        self.scores = temp;
        //Flush to disk
        [self flushScores];
    } else {
        //Read the plist file into dictionary
        NSPropertyListFormat format;
        NSString *errorDesc = nil;
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        self.scores = (NSMutableDictionary *)[NSPropertyListSerialization
                                       propertyListFromData:plistXML
                                       mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                       format:&format
                                       errorDescription:&errorDesc];
    }
}
- (void) writeScoreMinutes:(int) minute Seconds:(int)second ForDifficulty:(NSString *)difficulty grid:(int)grids
{
    NSString* key = [NSString stringWithFormat:@"%@%d", difficulty, grids];
    NSArray* obj = [NSArray arrayWithObjects:[NSNumber numberWithInt:minute], [NSNumber numberWithInt:second], nil];
    [self.scores setObject:obj forKey:key];
}
- (NSArray*) readScoreForDifficulty:(NSString *)difficulty grid:(int)grids
{
    NSString* key = [NSString stringWithFormat:@"%@%d", difficulty, grids];
    return [self.scores objectForKey:key];
}
- (void) flushScores
{
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Scores.plist"];
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:self.scores
                                        format:NSPropertyListXMLFormat_v1_0
                                        errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else {
        NSLog(error);
        [error release];
    }
}
- (id)init
{
    if (self = [super init]) {
        self.keys = [NSArray arrayWithObjects:@"EASY4", @"EASY5", @"EASY6", @"DIFFICULT6", 
                     @"EASY7", @"DIFFICULT7", @"EASY8", @"DIFFICULT8", nil];
        [self readScores];
    }
    return self;
}

@end
