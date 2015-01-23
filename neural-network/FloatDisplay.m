//
//  FloatDisplay.m
//  neural-network
//
//  Created by oyabunn on 1/23/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#import "FloatDisplay.h"

@implementation FloatDisplay


- (void)setX:(float *)x Y:(float *)y length:(unsigned int)length
{
    _x = x;
    _y = y;
    _length = length;
}

- (void)setMaxX:(float)x
{
    _maxX = x;
}

- (void)setMaxY:(float)y
{
    _maxY = y;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1] set];
    NSRectFill(NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    if (!_x || !_y || !_maxX || !_maxY)
        return;
    
    CGFloat width = self.bounds.size.width / _maxX;
    CGFloat height = self.bounds.size.height / _maxY;
    
    [[NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:1] set];
    NSBezierPath *path = nil;
    if (self.drawLine) {
        path = [NSBezierPath bezierPath];
    }
    for (unsigned int i=0; i<_length; i++) {
        CGFloat x = _x[i] * width;
        CGFloat y = _y[i] * height;
        if (self.drawLine) {
            if (i==0) {
                [path moveToPoint:NSMakePoint(x, y)];
            } else {
                [path lineToPoint:NSMakePoint(x, y)];
            }
        } else {
            NSRectFill(NSMakeRect(x, y, 1, 1));
        }
    }
    if (self.drawLine) {
        [path stroke];
    }
}

@end
