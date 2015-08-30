//
//  GameSprite.h
//  Towers
//
//  Created by 雷 王 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Game.h"
#import "ScratchSprite.h"

#import "Dimensions.h"

@class GameScreen;

typedef enum{NORMAL, SCRATCH} GameMode;
typedef enum{EASY, HARD} GameDifficulty;

@protocol GameSuccessProtocol <NSObject>

- (void) gameSucceeded;
- (void) setPickerValues: (NSMutableSet*) set;

@end

@interface GameSprite : CCSprite
{
    float cellSize;
    NSMutableArray* spriteArray;
    NSMutableArray* spritesLeft;
    NSMutableArray* spritesRight;
    NSMutableArray* spritesTop;
    NSMutableArray* spritesBottom;
    CCSprite* highlightSprite;
}

@property (nonatomic, retain) Game* game;

@property (nonatomic) GameMode mode;

@property (nonatomic, retain) NSMutableArray* matrix;

@property (nonatomic, retain) NSMutableArray* scratch;

@property (nonatomic) int gridSize;

@property (nonatomic, retain) id<GameSuccessProtocol> delegate;
@property (nonatomic) BOOL hasFocus;
@property (nonatomic) int focusX;
@property (nonatomic) int focusY;

- (id) initWithGameDifficulty:(GameDifficulty) difficulty size: (int) size;
- (id) initWithGameDifficulty:(GameDifficulty) difficulty size: (int) size fromDisk:(BOOL) fromDisk;

- (void) restart;
- (BOOL) checkNumber: (int) number AtX: (int)x Y:(int) y;
- (BOOL) checkAll;
- (void) enterNumberAtX:(int) x Y: (int) y;
- (void) clearNumberAtX:(int)x Y:(int)y;
- (void) scratchNumbers: (NSArray*) numbers AtX: (int) x Y: (int)y;
- (void) touchGameAtX: (float) x Y: (float) y;

- (UIImage*) convertToImage;

@end
