//
//  AppDelegate.h
//  neural-network
//
//  Created by oyabunn on 1/22/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FloatDisplay;

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet FloatDisplay *floatDisplayView;

@end

