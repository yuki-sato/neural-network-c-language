//
//  FloatDisplay.h
//  neural-network
//
//  Created by oyabunn on 1/23/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FloatDisplay : NSView
{
    float *_x;
    float *_y;
    unsigned int _length;
    float _maxX;
    float _maxY;
}
@property (nonatomic, readwrite) BOOL drawLine;

- (void)setX:(float *)x Y:(float *)y length:(unsigned int)length;

- (void)setMaxX:(float)x;
- (void)setMaxY:(float)y;

@end
