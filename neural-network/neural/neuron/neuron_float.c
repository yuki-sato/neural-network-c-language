//
//  neuron_float.c
//  neural-network
//
//  Created by oyabunn on 1/22/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#include "neuron_float.h"

#include <math.h>
#include <stdio.h>


//=======================================================//
#pragma mark --- GlobalVarirables
//=======================================================//
static float alpha = 0;
static float epsilon = 0;

void neuron_set_params(float newAlpha, float newEpsilon)
{
    alpha = newAlpha;
    epsilon = newEpsilon;
}

//=======================================================//
#pragma mark --- Neural
//=======================================================//
void neuron_float_process(float *output, const float input[], const float weight[], unsigned int inputCount)
{
//    printf("\n");
    float x = 0;
    while (inputCount--) {
        // Attention. if too many inputCount or each value range are too far(like 10^3 and 10^-3). then result is not good
        x += input[inputCount] * weight[inputCount];
//        printf("  %.1f", input[inputCount] * weight[inputCount]);
    }
//    printf("\n");
//    printf("x:%f\n",x);
//    printf("val: %f\n", expf(-alpha * (x)));
    *output = 1.0f/(1.0f+expf(-alpha * (x)));
//    printf("sigmoid(x)= %f", *output);
    
}

void neuron_float_sum(float *output, const float input[], const float weight[], unsigned int inputCount)
{
    float x = 0;
    while (inputCount--) {
        // Attention. if too many inputCount or each value range are too far(like 10^3 and 10^-3). then result is not good
        x += input[inputCount] * weight[inputCount];
    }
    *output = x;
}

//=======================================================//
#pragma mark --- BackPropagation
//=======================================================//

// calc ΔE/Δs using next level
void neuron_float_fill_influence_level(
                                  float         *influence,
                                  const float   *output,
                                  const float   nextInfluencee[],
                                  unsigned int  nextCount,
                                  const float   nextWeight[],
                                  const unsigned int indexInSameLayer,
                                  const unsigned int sameLayerCount)
{
    *influence = 0;
    while(nextCount--) {
        (*influence) += nextInfluencee[nextCount] * nextWeight[nextCount*(sameLayerCount + 1) + indexInSameLayer];
    }
    (*influence) *= alpha * (*output) * (1 - (*output));
}

void neuron_float_little_adjust(const float *influence, const float input[], float weight[], unsigned int inputCount)
{
    printf("[");
    while (inputCount--) {
        weight[inputCount] -= epsilon * (*influence) * input[inputCount];
        printf(" %f", -epsilon * (*influence) * input[inputCount]);
    }
    printf("] ");
}

//=======================================================//
#pragma mark --- Simple error correction one node
//=======================================================//
void neuron_float_little_adjust_weight_at(float *output, float *desiredOutput, float input[], float weight[], unsigned int index)
{
    weight[index] -= epsilon * (-2.0f * (*desiredOutput - *output) * alpha * (*output) * (1 - (*output))) * input[index];
}

// change values a little all of input weight
void neuron_float_little_adjust_weight_all(float *output, float *desiredOutput, float input[], float weight[], unsigned int inputCount)
{
    while (inputCount--) {
        neuron_float_little_adjust_weight_at(output, desiredOutput, input, weight, inputCount);
    }
}