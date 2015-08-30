//
//  PickerSprite.m
//  Towers
//
//  Created by 雷 王 on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PickerSprite.h"

@implementation PickerSprite
@synthesize mode = _mode;
@synthesize gridSize = _gridSize;
@synthesize selected = _selected;
@synthesize delegate = _delegate;

- (id) initWithGridSize:(int)size
{
    if (self =[super init]) {
        self.gridSize = size;
        self.mode = SINGLE;
        self.selected = [NSMutableArray array];
        [self.selected retain];
        
        //load the sprites
      
        //Create the sprites and add them to the picker
        NSMutableArray* array = [NSMutableArray array];
        circleSprites = [NSMutableArray array];
        [circleSprites retain];
        //The width of the picker should be distributed evenly among the numbers and erasor
        float cellWidth = PICKERWIDTH / (self.gridSize +1);
        for (int i =1; i<=self.gridSize; i++) {
            CCSprite* number = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"number%d.png", i]];
            
            number.position = CGPointMake(cellWidth/2 + (i-1)*cellWidth, PICKERHEIGHT/2);
            [self addChild:number];
            [array addObject:number];
            //Add the corresponding Circle
            [circleSprites addObject:[NSNull null]];
        }
        numberSprites = array;
        [numberSprites retain];
        //Create the erasor sprite
        erasor = [CCSprite spriteWithFile:@"erasor.png"];
        erasor.position = CGPointMake(PICKERWIDTH - cellWidth/2, PICKERHEIGHT/2);
        [self addChild:erasor];
    } 
    return self;
}
- (void) addCircleSpriteAtPosition:(int) x
{
    CCSprite* circle = [CCSprite spriteWithSpriteFrameName:@"circle.png"];
    
    CCSprite* number = [numberSprites objectAtIndex:x];
    circle.position = number.position;
    [circleSprites replaceObjectAtIndex:x withObject:circle];
    [self addChild:circle];
}
- (void) removeCircleSpriteAtPosition:(int)x
{
    [self removeChild:[circleSprites objectAtIndex:x] cleanup:YES];
    [circleSprites replaceObjectAtIndex:x withObject:[NSNull null]];
}
-(void) clearSelected
{
    //[_selected release];
    _selected = [NSMutableArray array];
    [_selected retain];
    for (int i=0;i<self.gridSize;i++)
    {
        if([circleSprites objectAtIndex:i] != [NSNull null]){
            [self removeCircleSpriteAtPosition:i];
        }
    }
}
- (void) setSelection: (NSMutableArray*) set
{
    for(NSNumber* number in set) {
        [self.selected addObject:number];
        int poisition = [number intValue]-1;
        [self addCircleSpriteAtPosition:poisition];
    }
}
- (void) setMode:(PickerMode)mode
{
    _mode = mode;
    [self clearSelected];
    if(mode == MULTIPLE){
        NSSet* scratched = [self.delegate getCurrentScratchNumbers];
        [self setSelection:scratched];
        erasor.visible = NO;
    }else{
        erasor.visible = YES;
    }
}
- (void) setSelected:(NSMutableArray *)selected
{
    [self clearSelected];
    if(self.mode == MULTIPLE){
        [self setSelection:selected];
    }
}

- (void) touchPickerAtX:(float)x Y:(float)y
{
    int touched = 0;
    for (int i = 0; i<self.gridSize; i++) {
        CCSprite* number = [numberSprites objectAtIndex:i];
        float xx = number.position.x - PICKERHEIGHT/2;
        float yy = number.position.y - PICKERHEIGHT/2;
        CGRect rect = CGRectMake(xx, yy, PICKERHEIGHT, PICKERHEIGHT);
        if(CGRectContainsPoint(rect, CGPointMake(x, y)))
        {
            touched = i+1;
            break;
        }
    }
    //Handle eraser touch
    if (touched == 0) {
        CGRect eraserRect = CGRectMake(PICKERWIDTH - PICKERHEIGHT, 0, PICKERHEIGHT, PICKERHEIGHT);
        if (erasor.visible && CGRectContainsPoint(eraserRect, CGPointMake(x, y))) {
            NSLog(@"erasor tapped");
            [self.delegate onPickingNumber:0];
        }
        return;
    }    
    if (self.mode==SINGLE) {
        //First clear the selections, then add the single selected
        //[self.selected release];
        self.selected = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:(touched)]];
        //Add the circle sprite
        [self addCircleSpriteAtPosition:touched-1];
    } else {
        //First check if the number has been selected
        if ([self.selected containsObject:[NSNumber numberWithInt:touched]]) {
            [self.selected removeObject:[NSNumber numberWithInt:touched]];
            //Remove the circle sprite
            [self removeCircleSpriteAtPosition:touched-1];
        } else {
            [self.selected addObject:[NSNumber numberWithInt:touched]];
            [self addCircleSpriteAtPosition:touched-1];
        }
    }
    //Finally, tell the delegate we are done
    [self.delegate onPickingNumber:touched];
    
}

@end
