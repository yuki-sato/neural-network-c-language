//
//  NeuralNetwork.h
//  neural-network
//
//  Created by oyabunn on 1/23/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeuralNetwork : NSObject
{
    
}

// preparement
- (void)setAlpha:(float)alpha;
- (void)setEpsilon:(float)epsilon;
- (void)buildNetwork:(unsigned int)numberOfNodeInLayer layerCount:(unsigned int)layerCount;
- (void)setRandomWeights:(unsigned int)range;       // must call after buildNetwork

// process
- (void)processNetwork:(float *)inputs results:(float *)results count:(unsigned int)count;
- (void)processBackPropagation:(float *)inputs results:(float *)results desiredResults:(float *)desiredResults count:(unsigned int)count;

// prints
- (void)printOutpus;
- (void)printWeights;

@end
