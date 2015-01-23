//
//  neuron_float_network.c
//  neural-network
//
//  Created by oyabunn on 1/22/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#include "neuron_float_network.h"
#include "neuron_float.h"
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

//=======================================================//
#pragma mark --- Struct
//=======================================================//

typedef enum _NodeType {

    nodeTypeNuron = 0,
    nodeTypeCopy,
    nodeTypeSum

}NodeType;

typedef struct _neuronFloatLayer {
    
    struct _neuronFloatLayer *previousLayer;
    struct _neuronFloatLayer *nextLayer;
    
    NodeType type;
    
    unsigned int nodeCount;
    float   *output;
    float   *weight;
    float   *influence;
    
}neuronFloatLayer;

//=======================================================//
#pragma mark --- Global Varirables
//=======================================================//
neuronFloatLayer *topLayer = NULL;
neuronFloatLayer *lastLayer = NULL;

//=======================================================//
#pragma mark --- Layer Control
//=======================================================//
void free_layer(neuronFloatLayer *layer)
{
    if (layer->output != NULL) free(layer->output);
    if (layer->weight != NULL) free(layer->weight);
    if (layer->influence != NULL) free(layer->influence);
}

neuronFloatLayer * create_layer(unsigned int numberOfNode, NodeType type)
{
    neuronFloatLayer *layer = (neuronFloatLayer *)malloc(sizeof(neuronFloatLayer));
    layer->type = type;
    layer->previousLayer = NULL;
    layer->nextLayer = NULL;
    layer->nodeCount = numberOfNode;
    layer->output = malloc(sizeof(float) * (numberOfNode + 1));
    layer->output[numberOfNode] = 1.0f;
    layer->weight = NULL;
    layer->influence = malloc(sizeof(float) * (numberOfNode));
    return layer;
}

void neuron_float_network_wire_layer(neuronFloatLayer *previousLayer, neuronFloatLayer *nextLayer)
{
    unsigned int previousNodeCount = previousLayer->nodeCount;
    if (nextLayer->weight != NULL) {
        free(nextLayer->weight);
    }
    nextLayer->weight = malloc(sizeof(float) * ((previousNodeCount + 1) * nextLayer->nodeCount));
}

void neuron_float_network_remove_all_layer()
{
    neuronFloatLayer *buf;
    while (topLayer != NULL) {
        free_layer(topLayer);
        buf = topLayer->nextLayer;
        free(topLayer);
        topLayer = buf;
    }
    lastLayer = NULL;
}

void neuron_float_network_add_layer(unsigned int numberOfNode, NodeType type)
{
    neuronFloatLayer *newLayer = create_layer(numberOfNode, type);
    
    if (topLayer == NULL) {
        topLayer = newLayer;
        lastLayer = newLayer;
        newLayer->weight = malloc(sizeof(float) * ((numberOfNode + 1) * numberOfNode));
    } else {
        lastLayer->nextLayer = newLayer;
        newLayer->previousLayer = lastLayer;
        neuron_float_network_wire_layer(lastLayer, newLayer);
        lastLayer = newLayer;
    }
}

//=======================================================//
#pragma mark --- Construct
//=======================================================//

void neuron_float_network_build_one_n_m_one(unsigned int numberOfNodeInLayer, unsigned int numberOfLayer)
{
    neuron_float_network_remove_all_layer();
    
    // first layer dispatcher
    // this is required layer.
    neuron_float_network_add_layer(numberOfNodeInLayer, nodeTypeCopy);
    
    while (numberOfLayer--) {
        neuron_float_network_add_layer(numberOfNodeInLayer, nodeTypeNuron);
    }
    
    // last layer sum all of result
    neuron_float_network_add_layer(1, nodeTypeSum);
    
}

void neuron_float_network_set_random_weight(unsigned int range)
{
    srand((unsigned)time(NULL));
    neuronFloatLayer *layer = topLayer;
    if (!layer || range == 0) {
        return;
    }
    while (layer->nextLayer) {
        unsigned int count = (layer->nodeCount + 1 );
        layer = layer->nextLayer;
        count *= layer->nodeCount;
        while (count--) {
            layer->weight[count] = ((float)(rand() % range) / range);
        }
    }
}


//=======================================================//
#pragma mark --- Layer Utils
//=======================================================//

void layer_copy_data(float *input, neuronFloatLayer *layer)
{
    unsigned int count = layer->nodeCount;
    while (count--) {
        layer->output[count] = *input;
    }
}

void layer_process_data(neuronFloatLayer *layer)
{
    unsigned int count = layer->nodeCount;
    unsigned int previousNodeCount = layer->previousLayer->nodeCount;
    while (count--) {
        neuron_float_process(
                             &(layer->output[count]),
                             layer->previousLayer->output,
                             &(layer->weight[(layer->nodeCount + 1) * count]),  // +1 means dummy for theta
                             previousNodeCount + 1);
    }
}

void layer_sum_data(neuronFloatLayer *layer)
{
    if (layer->previousLayer == NULL) {
        // stupid programmer
        return;
    }
    unsigned int count = layer->nodeCount;
    while (count--) {
        unsigned int connectionCount = layer->previousLayer->nodeCount;
        layer->output[count] = 0;
        while (connectionCount--) {
            layer->output[count] += layer->previousLayer->output[connectionCount];
        }
    }
}

//=======================================================//
#pragma mark - Network Utils -
//=======================================================//

void neuron_float_network_config(float alpha, float epsilon)
{
    neuron_set_params(alpha, epsilon);
}

void neuron_float_network_process(float *input, float *output)
{
    neuronFloatLayer *layer = topLayer;
    while (layer != NULL) {
        switch (layer->type) {
            case nodeTypeCopy:
                layer_copy_data(input, layer);
                break;
            case nodeTypeNuron:
                layer_process_data(layer);
                break;
            case nodeTypeSum:
                layer_sum_data(layer);
                break;
            default:
                break;
        }
        
        layer = layer->nextLayer;
    }
    
    *output = lastLayer->output[0];
}

//=======================================================//
#pragma mark - Probe -
//=======================================================//

float * neuron_float_network_proble_weight(unsigned int indexInlayer, unsigned int layerIndex, unsigned int *length)
{
    neuronFloatLayer *layer = topLayer;
    for (unsigned int i=0; layer != NULL; i++) {
        if (i != layerIndex){
            layer = layer->nextLayer;
            continue;
        }
        *length = layer->previousLayer->nodeCount + 1;
        return &(layer->weight[(*length) * indexInlayer]);
    }
    return NULL;
}

float neuron_float_network_proble_output(unsigned int indexInlayer, unsigned int layerIndex)
{
    neuronFloatLayer *layer = topLayer;
    for (unsigned int i=0; layer != NULL; i++) {
        if (i != layerIndex){
            layer = layer->nextLayer;
            continue;
        }
        return layer->output[indexInlayer];
    }
    return 0;
}

unsigned int neuron_float_network_node_count(unsigned int layerIndex)
{
    neuronFloatLayer *layer = topLayer;
    for (unsigned int i=0; layer != NULL; i++) {
        if (i != layerIndex){
            layer = layer->nextLayer;
            continue;
        }
        return layer->nodeCount;
    }
    return 0;
}
