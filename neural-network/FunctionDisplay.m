//
//  FunctionDisplay.m
//  neural-network
//
//  Created by oyabunn on 1/23/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#import "FunctionDisplay.h"

@implementation FunctionDisplay

- (void)setStartX:(float)startX endX:(float)endX maxY:(float)y
{
    _startX = startX;
    _endX = endX;
    _maxY = y;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:1] set];
    NSRectFill(NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    if (_endX <= _startX || !self.delegate)
        return;
    
    CGFloat width = self.bounds.size.width;
    CGFloat yScale = self.bounds.size.height / _maxY;
    
    NSUInteger numberOfFunction = [self.delegate numberOfFunction];
    for (unsigned int functionIndex=0; functionIndex<numberOfFunction; functionIndex++) {
        [[self.delegate colorForFunction:functionIndex] set];
        NSBezierPath *path = nil;
        path = [NSBezierPath bezierPath];
        for (unsigned int i=0; i<width; i++) {
            CGFloat x = (_endX - _startX) * i / width + _startX;
            CGFloat y = [self.delegate functionCalc:x functionIndex:functionIndex] * yScale;
            if (i==0) {
                [path moveToPoint:NSMakePoint(i, y)];
            } else {
                [path lineToPoint:NSMakePoint(i, y)];
            }
        }
        [path stroke];
    }
}

@end
