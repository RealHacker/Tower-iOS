//
//  ScratchSprite.m
//  Towers
//
//  Created by 雷 王 on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScratchSprite.h"

@implementation ScratchSprite

@synthesize selectedNumbers = _selectedNumbers;

- (CGPoint) calculatePositionFor:(int) number
{
    float cellWidth = GAMEWIDTH/((gridCount+2)*3);
    
    float x = 0.0;
    float y = 0.0;
    if (gridCount <= 5) {
        switch (number) {
            case 1:
                x = cellWidth/2;
                y = cellWidth*3/2;
                break;
            case 2:
                x = cellWidth*3/2;
                y = 5* cellWidth/2;
                break;
            case 3:
                x = 5* cellWidth/2;
                y = cellWidth*3/2;
                break;
            case 4:
                x = cellWidth*3/2;
                y = cellWidth/2;
                break;
            case 5:
                x = cellWidth*3/2;
                y = cellWidth*3/2;
                break;
            default:
                break;
        }
    } else {
        int i = 2 - (number-1)/3;
        int j = (number-1)%3;
        x = cellWidth * j +cellWidth/2;
        y = cellWidth * i + cellWidth/2;
    }
    x-= GAMEWIDTH/((gridCount+2)*2);
    y-= GAMEWIDTH/((gridCount+2)*2);
    return CGPointMake(x, y);
}
- (void) resetSprites
{
    for (CCSprite* sprite in sprites) {
        [self removeChild:sprite cleanup:YES];
    }
    //[sprites release];
    for (int i=0; i<[self.selectedNumbers count]; i++) {
        int n = [[self.selectedNumbers objectAtIndex:i] intValue];
        CCSprite* numberSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"scratch%d.png", n]];
        numberSprite.position = [self calculatePositionFor:n];
        [sprites addObject:numberSprite];
        [self addChild:numberSprite];
    }
}
- (void) setSelectedNumbers:(NSMutableArray *)selectedNumbers
{
    //[_selectedNumbers release];
    _selectedNumbers = selectedNumbers;
    [self resetSprites];
}
- (id) initWithNumbers:(NSMutableArray *)numbers Count:(int)count
{
    if (self = [super init]) {
        //float cellWidth = GAMEWIDTH/(count+2);
        //make the pink square fit in
        //self.scale = cellWidth/50.0;
        self.anchorPoint =  CGPointMake(0, 0);
        gridCount = count;
        self.selectedNumbers = numbers;
    }
    return self;
}

@end
