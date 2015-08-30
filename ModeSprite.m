//
//  ModeSprite.m
//  Towers
//
//  Created by 雷 王 on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModeSprite.h"

@implementation ModeSprite

@synthesize mode = _mode;
@synthesize delegate = _delegate;

- (id) initWithMode:(GameMode)mode
{
    self.mode = mode;
    if(mode==NORMAL){
        self = [super initWithSpriteFrameName:@"pencil0.png"];
    }else{
        self = [super initWithSpriteFrameName:@"pencil1.png"] ;
    }
    return self;
}
- (void) touchSpriteAtX:(float)x Y:(float)y
{
    CGPoint point = CGPointMake(x, y);
    CGRect rect = CGRectMake(0, 0, MODEWIDTH, MODEWIDTH);
    if (CGRectContainsPoint(rect, point)) {
        if (self.mode == NORMAL) {
            self.mode = SCRATCH;
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pencil1.png"]];
            [self.delegate modeChangedTo:SCRATCH];
        } else {
            self.mode = NORMAL;
            [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pencil0.png"]];
            [self.delegate modeChangedTo:NORMAL];
        }
    }
}



@end
