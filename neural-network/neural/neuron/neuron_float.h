//
//  neuron_float.h
//  neural-network
//
//  Created by oyabunn on 1/22/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#ifndef __neural_network__neuron_float__
#define __neural_network__neuron_float__

// call onece
void neuron_set_params(float newAlpha, float newEpsilon);

// calc output
void neuron_float_process(float *output, const float input[], const float weight[], unsigned int inputCount);

// for backpropagation
void neuron_float_fill_influence_level(
                                       float         *influence,
                                       const float   *output,
                                       const float   nextInfluencee[],
                                       unsigned int  nextCount,
                                       const float   nextWeight[],
                                       const unsigned int indexInSameLayer,
                                       const unsigned int sameLayerCount);
void neuron_float_fill_influence_level_last_layer(
                                                  float         *influence,
                                                  const float   *output,
                                                  const float   nextInfluence);

// backpropagation
void neuron_float_little_adjust(const float *influence, const float input[], float weight[], unsigned int inputCount);

#endif /* defined(__neural_network__neuron_float__) */
