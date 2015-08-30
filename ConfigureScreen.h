//
//  ConfigureScreen.h
//  Towers
//
//  Created by 雷 王 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Dimensions.h"
#import "ResourceLoader.h"

@interface ConfigureScreen : CCLayer
{
    NSMutableArray* numberSprites;
    NSMutableArray* numberTickedSprites;
    CCSprite* easyLabel;
    CCSprite* easySelectedLabel;
    CCSprite* hardLabel;
    CCSprite* hardSelectedLabel;
    CCSprite* go;
    
    CCMenu* gridSizeMenu;
    CCMenu* levelMenu;
    CCMenu* storeMenu;

}

@property (nonatomic) int gridCount;
@property (nonatomic, retain) NSString* difficulty;

+ (CCScene*) scene;

@end
