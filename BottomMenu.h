//
//  BottomMenu.h
//  Towers
//
//  Created by 雷 王 on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Facebook.h"

typedef enum{GAMEPAGE, HELPPAGE, SHAREPAGE, SCOREPAGE} PageType;
@interface BottomMenu : NSObject<FBRequestDelegate>

{
    CCMenuItemLabel* gameLabel;
    CCMenuItemLabel* helpLabel;
    CCMenuItemLabel* shareLabel;
    CCMenuItemLabel* scoreLabel;
    
    BOOL WeiboImagePosted;
    Facebook* fb;
}

@property (nonatomic, retain) CCMenu* menu;
@property (nonatomic) PageType pageType;

@end
