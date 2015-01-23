//
//  AppDelegate.m
//  neural-network
//
//  Created by oyabunn on 1/22/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#import "AppDelegate.h"

#import "NeuralNetwork.h"

@interface AppDelegate ()
{
    NeuralNetwork *_network;
}
@property (weak) IBOutlet NSTextField *nodeInLayerTextField;
@property (weak) IBOutlet NSTextField *layersTextField;
@property (weak) IBOutlet NSTextField *alphaField;
@property (weak) IBOutlet NSTextField *epsilonField;
@property (weak) IBOutlet NSTextField *weightRangeField;

- (IBAction)buttonProcessPressed:(id)sender;
- (IBAction)buttonStudyPressed:(id)sender;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    
}

- (IBAction)buttonProcessPressed:(id)sender
{
    [self prepareNetwork];
    
    float x;
    float y;
    float result;
    
    x = 1;
    y = [self function:x];
    [_network printWeights];
    [_network processNetwork:&x results:&result count:1];
    [_network printOutpus];
}

- (IBAction)buttonStudyPressed:(id)sender
{
    [self prepareNetwork];
    
    float x;
    float y;
    float result;
    
    x = 1;
    y = [self function:x];
    [_network printWeights];
    [_network processBackPropagation:&x results:&result desiredResults:&y count:1 traningCount:10];
    [_network printOutpus];
}

//=======================================================//
#pragma mark - Function -
//=======================================================//

- (float)function:(float)x
{
    return x*x;
}

//=======================================================//
#pragma mark - Network -
//=======================================================//

- (void)prepareNetwork
{
    if (!_network) {
        _network = [[NeuralNetwork alloc] init];
        [_network setAlpha:self.alphaField.floatValue];
        [_network setEpsilon:self.epsilonField.floatValue];
        [_network buildNetwork:(unsigned int)self.nodeInLayerTextField.integerValue layerCount:(unsigned int)self.layersTextField.integerValue];
        [_network setRandomWeights:(unsigned int)self.weightRangeField.integerValue];
#ifdef DEBUG
        NSLog(@"preparedNetwork");
        NSLog(@"Alpha: %f", self.alphaField.floatValue);
        NSLog(@"Epsilon: %f", self.epsilonField.floatValue);
        NSLog(@"Layer %d:%d", (unsigned int)self.nodeInLayerTextField.integerValue ,(unsigned int)self.layersTextField.integerValue);
        NSLog(@"WeightRange %d", (unsigned int)self.weightRangeField.integerValue);
#endif
    }
}

@end
