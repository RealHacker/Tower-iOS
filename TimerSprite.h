//
//  TimerSprite.h
//  Towers
//
//  Created by 雷 王 on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Dimensions.h"

@interface TimerSprite : CCSprite
{
    BOOL isRunning;
    CCLabelTTF* timer;
    CCLabelTTF* mirror;
}

@property (nonatomic) int minutes;
@property (nonatomic) int seconds;

- (void) pause;
- (void) run;
- (NSString*) getTimeString;
- (void) resetTimer;

- (id) initWithMinute: (int) minute Second:(int) second;


@end
