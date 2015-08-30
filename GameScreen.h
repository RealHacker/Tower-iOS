//
//  GameScreen.h
//  Towers
//
//  Created by 雷 王 on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameSprite.h"
#import "PickerSprite.h"
#import "ModeSprite.h"
#import "TimerSprite.h"
#import "BottomMenu.h"
#import "GameScores.h"

#import "Dimensions.h"

#import "Facebook.h"



@interface GameScreen : CCLayer <GameSuccessProtocol, PickerDelegateProtocol, ModeChangeProtocol, 
                UIActionSheetDelegate, FBRequestDelegate, FBLoginDialogDelegate>

@property (nonatomic) int gridSize;
@property (nonatomic) GameDifficulty difficulty;
@property (nonatomic) GameMode mode;

@property (nonatomic) BOOL resumed;

@property (nonatomic, retain) GameSprite* game;
@property (nonatomic, retain) PickerSprite* picker;
@property (nonatomic, retain) ModeSprite* selector;
@property (nonatomic, retain) TimerSprite* timer;
@property (nonatomic, retain) CCSprite* refreshButton;
@property (nonatomic, retain) CCSprite* backButton;
@property (nonatomic, retain) CCMenu* bottomMenu;

//@property (nonatomic, retain) BottomMenu* tabsMenu;

- (id) initWithDifficulty:(GameDifficulty) diff Size:(int) gridSize;
- (void) saveGame;

+ (CCScene*) sceneWithCount:(int)count Difficulty:(NSString*) difficulty;

@end