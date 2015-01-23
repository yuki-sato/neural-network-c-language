//
//  neuron_float_network.h
//  neural-network
//
//  Created by oyabunn on 1/22/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#ifndef __neural_network__neuron_float_network__
#define __neural_network__neuron_float_network__

// 0. construction

void neuron_float_network_build_one_n_m_one(unsigned int numberOfNodeInLayer, unsigned int numberOfLayer);
void neuron_float_network_set_random_weight(unsigned int range);

// 1. configration
void neuron_float_network_config(float alpha, float epsilon);


// 2. process
void neuron_float_network_process(float *input, float *output);
void neuron_float_network_backpropagation(float *lastOutput, float *desiredOutput);

// Probe Methods
float * neuron_float_network_proble_weight(unsigned int indexInlayer, unsigned int layerIndex, unsigned int *length);
float neuron_float_network_proble_output(unsigned int indexInlayer, unsigned int layerIndex);
unsigned int neuron_float_network_node_count(unsigned int layerIndex);

#endif /* defined(__neural_network__neuron_float_network__) */
