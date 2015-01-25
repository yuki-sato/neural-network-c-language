//
//  NeuralNetwork.m
//  neural-network
//
//  Created by oyabunn on 1/23/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#import "NeuralNetwork.h"

#include "neuron_float_network.h"

@interface NeuralNetwork()
{
    float _alpha;
    float _epsilon;
    
    unsigned int _nodeInLayer;
    unsigned int _layerCount;
}

@end

@implementation NeuralNetwork

//=======================================================//
#pragma mark - Memory -
//=======================================================//
- (instancetype)init
{
    self = [super init];
    if (self) {
        _alpha = 1;
        _epsilon = 0.01;
    }
    return self;
}


//=======================================================//
#pragma mark - Util -
//=======================================================//
- (void)_setParams
{
    neuron_float_network_config(_alpha, _epsilon);
}

#pragma mark - Network -
//=======================================================//
#pragma mark ---
//=======================================================//

- (void)setAlpha:(float)alpha
{
    _alpha = alpha;
    [self _setParams];
}

- (void)setEpsilon:(float)epsilon
{
    _epsilon = epsilon;
    [self _setParams];
}

//=======================================================//
#pragma mark --- init
//=======================================================//

- (void)buildNetwork:(unsigned int)numberOfNodeInLayer layerCount:(unsigned int)layerCount
{
    _nodeInLayer = numberOfNodeInLayer;
    _layerCount = layerCount;
    neuron_float_network_build_one_n_m_one(_nodeInLayer, _layerCount);
}

// range=2 weight will set range(0..1) integer
- (void)setRandomWeights:(unsigned int)range
{
    neuron_float_network_set_random_weight(range);
}

- (void)processNetwork:(float *)inputs results:(float *)results count:(unsigned int)count
{
    while (count--) {
        neuron_float_network_process(&inputs[count], &results[count]);
    }
}

- (void)processBackPropagation:(float *)inputs results:(float *)results desiredResults:(float *)desiredResults count:(unsigned int)count
{
    while(count--) {
        neuron_float_network_process(&inputs[count], &results[count]);
        neuron_float_network_backpropagation(&results[count], &desiredResults[count]);
    }
}

//=======================================================//
#pragma mark - Debug -
//=======================================================//

- (void)printOutpus
{
    printf("\nNodeOutputs ---------------");
    unsigned int layers = _layerCount+2; // include copynode and sumnode
    for (unsigned int layerIndex=0; layerIndex < layers; layerIndex++) {
        printf("\n%d:", layerIndex);
        unsigned int index=0;
        for (; index < (neuron_float_network_node_count(layerIndex) + 1); index++) {
            printf("\t%f", neuron_float_network_proble_output(index, layerIndex));
        }
    }
}

- (void)printWeights
{
    printf("\nNodeWeights ---------------");
    unsigned int layers = _layerCount+2; // include copynode and sumnode
    for (unsigned int layerIndex=1; layerIndex < layers; layerIndex++) {
        printf("\n%d:", layerIndex);
        unsigned int index=0;
        // per node
        for (; index < neuron_float_network_node_count(layerIndex); index++) {
            unsigned int length;
            float *weights = neuron_float_network_proble_weight(index, layerIndex, &length);
            printf("\t[");
            for (unsigned int weightIndex=0; weightIndex < length; weightIndex++) {
                printf(" %.3f", weights[weightIndex]);
            }
            printf("]");
        }
    }
}

@end
