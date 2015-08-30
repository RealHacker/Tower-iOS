//
//  HelpScreen.h
//  Towers
//
//  Created by 雷 王 on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface HelpScreen : CCLayer
{
    int index;
    CCSprite* bg;
    CCSprite* txt;
    CCSprite* backward;
    CCSprite* forward;
    CCSprite* done;
    
    NSMutableArray* offsets;
    NSMutableArray* bgs;
    NSMutableArray* slides;
}
@property (nonatomic) BOOL fromGame;

- (void) reset;
- (void) goBackward;
- (void) goForward;
- (void) helpDone;

+ (CCScene*) scene;
@end
