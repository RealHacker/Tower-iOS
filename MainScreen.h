//
//  MainScreen.h
//  Towers
//
//  Created by 雷 王 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "ResourceLoader.h"

@interface MainScreen : CCLayer <ResourceLoaderDelegate>
{
    CCSprite* logos;
    CCSprite* loadingSprite;
    
    CCMenu* menu;
    CCMenu* subMenu;
    CGSize winSize;
}

- (void) reset;
- (void) startGame;
- (void) startHelp;
-(void) startNewGame;
-(void) resumeGame;

+(CCScene*) scene;
@end
