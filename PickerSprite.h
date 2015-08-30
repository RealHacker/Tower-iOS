//
//  PickerSprite.h
//  Towers
//
//  Created by 雷 王 on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "Dimensions.h"

@protocol PickerDelegateProtocol <NSObject>

- (void) onPickingNumber: (int) number;
- (NSSet*) getCurrentScratchNumbers;

@end



typedef enum {SINGLE, MULTIPLE} PickerMode ;

@interface PickerSprite : CCSprite
{
    NSArray* numberSprites;
    NSMutableArray* circleSprites;
    CCSprite* erasor;
}

@property (nonatomic) PickerMode mode;

@property (nonatomic) int gridSize;

@property (nonatomic, retain) NSMutableArray* selected;

@property (nonatomic, retain) id<PickerDelegateProtocol> delegate;

- (id) initWithGridSize: (int) size;

- (void) touchPickerAtX: (float) x Y:(float) y;

@end
