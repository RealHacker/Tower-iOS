//
//  ScratchSprite.h
//  Towers
//
//  Created by 雷 王 on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "GameSprite.h"

@interface ScratchSprite : CCSprite
{
    NSMutableArray* sprites;
    int gridCount;
}

@property (nonatomic, retain) NSArray* selectedNumbers;

- (id) initWithNumbers: (NSArray*) numbers Count:(int) count;

@end
