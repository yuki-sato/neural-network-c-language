//
//  AppDelegate.m
//  neural-network
//
//  Created by oyabunn on 1/22/15.
//  Copyright (c) 2015 yuki-sato. All rights reserved.
//

#import "AppDelegate.h"
#import "FloatDisplay.h"
#import "FunctionDisplay.h"
#import "NeuralNetwork.h"

@interface AppDelegate () <FunctionDisplayProtocol>
{
    NeuralNetwork *_network;
    
    unsigned int _learnCount;
    float *_xx;
    float *_yy;
}
@property (weak) IBOutlet NSTextField *nodeInLayerTextField;
@property (weak) IBOutlet NSTextField *layersTextField;
@property (weak) IBOutlet NSTextField *alphaField;
@property (weak) IBOutlet NSTextField *epsilonField;
@property (weak) IBOutlet NSTextField *weightRangeField;
@property (weak) IBOutlet NSTextField *learnCountField;

- (IBAction)buttonProcessPressed:(id)sender;
- (IBAction)buttonStudyPressed:(id)sender;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.functionDisplayView.delegate = self;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
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
    NSDate *startDate = [[NSDate alloc] init];
    NSLog(@"Start BackPropagation-----");
    
    [self prepareNetwork];
    [_network printWeights];
    
    float x;
    float y;
    float result=0;
    
    for (NSUInteger i=0; i<_learnCount; i++) {
        x = (i%100)/100.0;
        y = [self function:x];
        [_network processBackPropagation:&x results:&result desiredResults:&y count:1];
        _yy[i] = result - y;
        if (_yy[i] < 0) _yy[i] *= -1;
    }
    [_network printOutpus];
    [_network printWeights];
    
    for (NSUInteger i=0; i<_learnCount; i++) {
        _xx[i] = (float)i;
    }
    
    self.floatDisplayView.drawLine = YES;
    [self.floatDisplayView setMaxY:1];
    [self.floatDisplayView setMaxX:_learnCount];
    [self.floatDisplayView setX:_xx Y:_yy length:_learnCount];
    [self.floatDisplayView setNeedsDisplay:YES];
    
    [self.functionDisplayView setStartX:0 endX:1 maxY:1];
    [self.functionDisplayView setNeedsDisplay:YES];
    printf("\ninterval %f", -[startDate timeIntervalSinceNow]);
}

//=======================================================//
#pragma mark - Function -
//=======================================================//

- (float)function:(float)x
{
    return x*x;
}

//=======================================================//
#pragma mark - FunctionDisplayViewDelegate -
//=======================================================//

-(NSUInteger)numberOfFunction
{
    return 2;
}

- (NSColor *)colorForFunction:(NSUInteger)functionIndex
{
    return [@[
              [NSColor colorWithCalibratedRed:1 green:0 blue:0 alpha:1],
              [NSColor colorWithCalibratedRed:0 green:1 blue:0 alpha:1]]
            objectAtIndex:functionIndex];
}

-(CGFloat)functionCalc:(CGFloat)x functionIndex:(NSUInteger)functionIndex
{
    if (functionIndex == 0) {
        return [self function:x];
    } else {
        float input = x;
        float result;
        [_network processNetwork:&input results:&result count:1];
        return result;
    }
}

//=======================================================//
#pragma mark - Network -
//=======================================================//

- (void)prepareNetwork
{
    _learnCount = self.learnCountField.intValue;
    if (_xx) free(_xx);
    if (_yy) free(_yy);
    
    _xx = malloc(sizeof(float) * _learnCount);
    _yy = malloc(sizeof(float) * _learnCount);
    
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

@end
