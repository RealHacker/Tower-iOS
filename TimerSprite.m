//
//  TimerSprite.m
//  Towers
//
//  Created by 雷 王 on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TimerSprite.h"

@implementation TimerSprite

@synthesize minutes = _minutes;
@synthesize seconds = _seconds;

- (void) pause
{
    isRunning = NO;
}
- (void) run
{
    isRunning = YES;
    
}
- (NSString *)getTimeString
{
    NSString* minutePart;
    if (self.minutes<=9) {
        minutePart = [NSString stringWithFormat:@"0%d", self.minutes];
    }else{
        minutePart = [NSString stringWithFormat:@"%d", self.minutes];
    }
    NSString* secondPart;
    if (self.seconds<=9) {
        secondPart = [NSString stringWithFormat:@"0%d", self.seconds];
    }else{
        secondPart = [NSString stringWithFormat:@"%d", self.seconds];
    }
    return [NSString stringWithFormat:@"%@:%@", minutePart, secondPart];
}
- (id) initWithMinute:(int)minute Second:(int)second
{
    if(self = [super initWithSpriteFrameName:@"TimerBg.png"])
    {
        self.minutes = minute;
        self.seconds = second;
        isRunning = NO;
        ccColor3B fontColor;
        fontColor.r = 0;
        fontColor.g = 0;
        fontColor.b = 0;

        timer = [CCLabelTTF labelWithString:[self getTimeString] fontName:@"Marker Felt" fontSize:15.0];
        timer.color = fontColor;
        timer.position = CGPointMake(5, 10);
        timer.anchorPoint = CGPointMake(0, 0);
        [self addChild:timer];
        
        mirror = [CCLabelTTF labelWithString:[self getTimeString] fontName:@"Marker Felt" fontSize:15.0];
        mirror.color = ccc3(128, 128, 128);
        mirror.flipY = YES;
        mirror.anchorPoint = CGPointMake(0, 1);
        mirror.position = CGPointMake(5, 10);
        [self addChild:mirror];
        
        [self schedule:@selector(timeUpdate:) interval:1.0];
    }
    return self;
}
- (void) timeUpdate: (ccTime)deltaTime
{
    if(isRunning) 
    {
        self.seconds += 1;
        if (self.seconds>=60) {
            self.minutes +=1;
            self.seconds -= 60;
        }
        [timer setString:[self getTimeString]];
        [mirror setString:[self getTimeString]];
    }
}
-(void) resetTimer
{
    self.minutes = 0;
    self.seconds = 0;
}
/*
- (void) visit
{
    if (!self.visible) {
        return;
    }
    glEnable(GL_SCISSOR_TEST);
    glScissor(0, -0, TIMERWIDTH, -TIMERHEIGHT);
    [super visit];
    glDisable(GL_SCISSOR_TEST);
}
*/
@end
