//
//  AppDelegate.m
//  neural-network
//
//  Created by oyabunn on 1/22/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#import "AppDelegate.h"
#import "FloatDisplay.h"
#import "NeuralNetwork.h"

#define TryNum 100

@interface AppDelegate ()
{
    NeuralNetwork *_network;
    
    float _xx[TryNum];
    float _yy[TryNum];
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
    
    x = 3;
    y = [self function:x];
    [_network printWeights];
    printf("\nBackPropagation------------");
    for (NSUInteger i=0; i<TryNum; i++) {
        [_network processBackPropagation:&x results:&result desiredResults:&y count:1];
        _yy[i] = result - y;
        if (_yy[i] < 0) _yy[i] *= -1;
    }
    [_network printOutpus];
    [_network printWeights];
    
    for (NSUInteger i=0; i<TryNum; i++) {
        _xx[i] = (float)i;
    }
    
    self.floatDisplayView.drawLine = YES;
    [self.floatDisplayView setMaxY:10];
    [self.floatDisplayView setMaxX:TryNum];
    [self.floatDisplayView setX:_xx Y:_yy length:TryNum];
    [self.floatDisplayView setNeedsDisplay:YES];
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
