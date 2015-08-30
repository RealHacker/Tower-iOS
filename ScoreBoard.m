//
//  ScoreBoard.m
//  Towers
//
//  Created by 雷 王 on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScoreBoard.h"
#import "ResourceLoader.h"

@implementation ScoreBoard


+ (CCScene*) scene
{
    static CCScene* scene = nil;
	// 'scene' is an autorelease object.
    if (scene == nil) {
        scene = [CCScene node];
        [scene retain];
        ScoreBoard *layer = [[ScoreBoard alloc] init];
        // add layer as a child to scene
        [scene addChild: layer];
	}
	// return the scene
	return scene;

}
- (NSString*) doubleDigitsFor:(int) number
{
    if (number<=9) {
        return [NSString stringWithFormat:@"0%d", number];
    } else {
        return [NSString stringWithFormat:@"%d", number];
    }
}
- (id) init
{
    if (self = [super init]) {
        
        CCSprite* bg = [CCSprite spriteWithFile:@"bg.png"];
        [bg setAnchorPoint:ccp(0,0)];
        [bg setPosition:ccp(0,0)];
        [self addChild:bg];
        
        CCSprite* template = [ResourceLoader sharedLoader].statsTemplate;
        [template setAnchorPoint:ccp(0,0)];
        [template setPosition:ccp(0,0)];
        [self addChild:template];

        CCSprite* backButton = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        backButton.anchorPoint = CGPointMake(0, 1);
        backButton.position = CGPointMake(0, SCREENHEIGHT);
        backButton.scale = 0.6;
        [self addChild:backButton];
        
        NSDictionary* dict = [GameScores sharedGameScores].scores;
        
        float y = BOARDHEIGHT-BOARDHEADERHEIGHT;
        for (int i = 4; i<=8; i++) {
            NSString* keyEasy = [NSString stringWithFormat:@"EASY%d", i];
            NSString* keyHard = [NSString stringWithFormat:@"DIFFICULT%d", i];
            NSArray* pairEasy = [dict objectForKey:keyEasy];
            
            int minuteEasy = [[pairEasy objectAtIndex:0] intValue];
            int secondEasy = [[pairEasy objectAtIndex:1] intValue];
            NSString* scoreEasy;
            if (minuteEasy ==0 && secondEasy ==0) {
                scoreEasy = @"NO SCORE";
            } else {
                scoreEasy = [NSString stringWithFormat:@"%@:%@", 
                                   [self doubleDigitsFor:minuteEasy],
                                   [self doubleDigitsFor:secondEasy]];
            }
            CCLabelBMFont* labelEasy = [CCLabelBMFont labelWithString:
                                     [NSString stringWithFormat:@"%d*%d EASY", i, i] fntFile:@"arial16.fnt"];
            labelEasy.color = ccc3(0, 0, 0);
            CCLabelBMFont* labelEasyScore = [CCLabelBMFont labelWithString: scoreEasy fntFile:@"arial16.fnt"];
            labelEasyScore.color = ccc3(0, 0, 0);
            
            y = y - SCOREHEIGHT;
            labelEasy.position = ccp(50, y);
            labelEasy.anchorPoint = ccp(0, 0);
            labelEasyScore.position = ccp(180, y);
            labelEasyScore.anchorPoint = ccp(0,0);
            [self addChild:labelEasy];
            [self addChild:labelEasyScore];
            
            //If we have the difficult level
            if ([dict valueForKey:keyHard]) {
                NSArray* pairHard = [dict objectForKey:keyHard];
                int minuteHard = [[pairHard objectAtIndex:0] intValue];
                int secondHard = [[pairHard objectAtIndex:1] intValue];
                NSString* scoreHard;
                if (minuteHard ==0 && secondHard ==0) {
                    scoreHard = @"NO SCORE";
                } else {
                    scoreHard = [NSString stringWithFormat:@"%@:%@", 
                                 [self doubleDigitsFor:minuteHard],
                                 [self doubleDigitsFor:secondHard]];
                }

                CCLabelBMFont* labelHard = [CCLabelBMFont labelWithString:
                                         [NSString stringWithFormat:@"%d*%d HARD", i, i] fntFile:@"arial16.fnt"];
                labelHard.color = ccc3(0, 0, 0);
                
                CCLabelBMFont* labelHardScore = [CCLabelBMFont labelWithString:scoreHard fntFile:@"arial16.fnt"];
                labelHardScore.color = ccc3(0, 0,0);
                
                y = y - SCOREHEIGHT;
                labelHard.position = ccp(50, y);
                labelHardScore.position = ccp(180, y);
                labelHard.anchorPoint = ccp(0, 0);
                labelHardScore.anchorPoint = ccp(0, 0);
                [self addChild:labelHard];
                [self addChild:labelHardScore];
            }
        }
        self.isTouchEnabled = true;
    }
    return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector]convertToGL:location];
    
    //Pass down to children
    CGRect backRect = CGRectMake(0, SCREENHEIGHT - 80, 80, 80);
    
    if (CGRectContainsPoint(backRect, location)) {
        [[CCDirector sharedDirector] popScene];
    }
}
@end
