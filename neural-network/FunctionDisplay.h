//
//  FunctionDisplay.h
//  neural-network
//
//  Created by oyabunn on 1/23/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol FunctionDisplayProtocol <NSObject>

- (NSUInteger)numberOfFunction;
- (NSColor *)colorForFunction:(NSUInteger)functionIndex;
- (CGFloat)functionCalc:(CGFloat)x functionIndex:(NSUInteger)functionIndex;

@end

@interface FunctionDisplay : NSView
{
    float _startX;
    float _endX;
    
    float _maxY;
}
@property (nonatomic, assign) id <FunctionDisplayProtocol>delegate;

- (void)setStartX:(float)startX endX:(float)endX maxY:(float)y;


@end
