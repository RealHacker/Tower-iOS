//
//  HelpScreen.m
//  Towers
//
//  Created by 雷 王 on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HelpScreen.h"
#import "GameAdView.h"

@implementation HelpScreen
@synthesize fromGame;
+(CCScene *)scene
{
    static CCScene* singleton = nil;
    static HelpScreen* help = nil;
    
    if(singleton == nil)
    {
        singleton = [CCScene node];
        [singleton retain];
        help = [[HelpScreen alloc] init];
        [singleton addChild:help];
    } else {
        [help reset];
    }
    GameAdView* ad = [GameAdView sharedAdView];
    ad.inGame = NO;
    if (ad.isAdVisible) {
        [ad hideBanner];
    }

    return singleton;
}

- (void)dealloc
{
    NSLog(@"dealloced...");
    [super dealloc];
}
-(id) init
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
 
    
    if (self = [super init]) {
        int offsetYs[6] = {100,100,100,130,100,260};

        offsets = [NSMutableArray array];
        [offsets retain];
        for (int i=0; i<6; i++) {
            [offsets addObject:[NSNumber numberWithInt:offsetYs[i]]];
        }
        //Load resources
        bgs = [NSMutableArray array];
        [bgs retain];
        slides = [NSMutableArray array];
        [slides retain];
        for (int i=1; i<=6; i++) {
            CCSprite* bgSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"tutor-bg%d.png", i]];
            [bgs addObject:bgSprite];
            CCSprite* slide = [CCSprite spriteWithFile:[NSString stringWithFormat:@"tutor%d.png", i]];
            [slides addObject:slide];
        }
        
        for (int i=0; i<6; i++) {
            CCSprite* background = (CCSprite*) [bgs objectAtIndex:i];
            [background setAnchorPoint:ccp(0,0)];
            [background setPosition:ccp(0,0)];
            [self addChild:background];
        }
        for (int i=0; i<6; i++) {
            CCSprite* slide = (CCSprite*) [slides objectAtIndex:i] ;
            [self addChild:slide];
        }
        
        backward = [CCSprite spriteWithFile:@"helpLeft.png"];
        [backward setAnchorPoint:ccp(0,0)];
        [backward setPosition:ccp(20,20)];
        [self addChild:backward];
       
        forward= [CCSprite spriteWithFile:@"helpRight.png"];
        [forward setAnchorPoint:ccp(0,0)];
        [forward setPosition:ccp(winSize.width-80,20)];
        [self addChild:forward];
                
        done = [CCSprite spriteWithFile:@"HelpOK.png"];
        [done setAnchorPoint:ccp(0,0)];
        [done setPosition:ccp(winSize.width-80,20)];
        [self addChild:done];
        
        [self reset];
        
        self.isTouchEnabled = true;
    }
    return self;
}
- (void)reset
{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    
    for (int i=0; i<6; i++) {
        CCSprite* slide = (CCSprite*) [slides objectAtIndex:i] ;
        [slide setAnchorPoint:ccp(0.5, 0.5)];
        int offset = [[offsets objectAtIndex:i] intValue];
        [slide setPosition: ccp(winSize.width*3/2, offset)];
    }
    for (int i=0; i<6; i++) {
        CCSprite* background = (CCSprite*) [bgs objectAtIndex:i];
        background.visible = false;
    }
    
    index = 0;
    
    bg = [bgs objectAtIndex:0];
    bg.visible = true;
    txt = [slides objectAtIndex:0];
    CCMoveTo* move = [CCMoveTo actionWithDuration:1 position:ccp(winSize.width/2, 100)];
    [txt runAction:move];
    
    backward.visible = false;
    forward.visible = true;
    done.visible = false;
}
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector]convertToGL:location];
    
    //Pass down to children
    CGRect leftRect = CGRectMake(0, 0 , 60, 60);
    CGRect rightRect = CGRectMake(winSize.width - 60, 0 , 60, 60);
    
    NSLog(@"%f, %f", location.x, location.y);
    if (CGRectContainsPoint(leftRect, location) && backward.visible) {
        [self goBackward];
    }else if (CGRectContainsPoint(rightRect, location) && forward.visible){
        [self goForward];
    } else if (CGRectContainsPoint(rightRect, location) && done.visible){
        [self helpDone];
    }

}
- (void) goBackward
{
    NSLog(@"back");
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    index--;
    bg.visible = false;

    bg = [bgs objectAtIndex:index];
    bg.visible = true;
    
    float offset1 = [[offsets objectAtIndex: index+1] intValue];
    float offset2 = [[offsets objectAtIndex: index] intValue];
    CCMoveTo* move1 = [CCMoveTo actionWithDuration:1 position:ccp(winSize.width*3/2, offset1)];
    [txt runAction:move1];
    txt = [slides objectAtIndex:index];
    CCMoveTo* move2 = [CCMoveTo actionWithDuration:1 position:ccp(winSize.width/2,offset2)];
    [txt runAction:move2];
    
    if (index ==0) {
        backward.visible = false;
    }
    forward.visible = true;
    done.visible = false;
    
}
- (void) goForward
{
    NSLog(@"forward");
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    NSLog(@"bgs:%d", [bgs count]);
    index++;
    bg.visible = false;
    bg = [bgs objectAtIndex:index];
    bg.visible = true;
    
    float offset1 = [[offsets objectAtIndex: index-1] intValue];
    float offset2 = [[offsets objectAtIndex: index] intValue];
    
    CCMoveTo* move1 = [CCMoveTo actionWithDuration:1 position:ccp(-winSize.width/2,offset1)];
    [txt runAction:move1];
    txt = [slides objectAtIndex:index];
    CCMoveTo* move2 = [CCMoveTo actionWithDuration:1 position:ccp(winSize.width/2,offset2)];
    [txt runAction:move2];
    
    if (index==5) {
        forward.visible = false;
        done.visible = true;
    } else{
        forward.visible = true;
        done.visible = false;
    }
    backward.visible = true;
}
- (void) helpDone 
{
    GameAdView* ad = [GameAdView sharedAdView];
    HelpScreen* screen = [[[HelpScreen scene] children] objectAtIndex:0];
    if (screen.fromGame) {
        ad.inGame = YES;
    }
    if (ad.isAdReady&& ad.inGame) {
        [ad showBanner];
    }

    [[CCDirector sharedDirector] popScene];
}
@end
