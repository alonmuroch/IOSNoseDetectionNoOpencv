//
//  ExtendedCIDetector.m
//  NoseDetectionNoOpencv
//
//  Created by Alon on 3/17/14.
//  Copyright (c) 2014 Alon. All rights reserved.
//

#import "ExtendedCIDetector.h"

#define TRIANGLE_CENTROID(p1,p2, p3) CGPointMake( (p1.x + p2.x + p3.x)/3, (p1.y + p2.y + p3.y)/3 )

@implementation ExtendedCIDetector

-(id)initWithType:(NSString *)type context:(CIContext *)context options:(NSDictionary *)options
{
    if ( self = [super init] ) { }
    return self;
}

-(void)detectorOfType:(NSString *)type context:(CIContext *)context options:(NSDictionary *)options
{
    baseCIDetector = [CIDetector detectorOfType:type context:context options:options];
}

- (NSMutableArray *)extendedFeaturesInImage:(CIImage *)image
{
    NSArray *arrFaceFeatures = [baseCIDetector featuresInImage:image];
    NSMutableArray *arrExtendedFeatures = [[NSMutableArray alloc] init];
    for(CIFaceFeature* faceFeature in arrFaceFeatures)
    {
        ExtendedCIFaceFeature *extFeatures = [[ExtendedCIFaceFeature alloc] initWithCIFaceFeature:faceFeature];
        [self findNose:extFeatures];
        [arrExtendedFeatures addObject:extFeatures];
    }
    return arrExtendedFeatures;
}

/*********************************
 Find extended features methods
 *********************************/

-(void)findNose:(ExtendedCIFaceFeature *)extFeatures
{
    if(extFeatures.hasLeftEyePosition &&
       extFeatures.hasRightEyePosition &&
       extFeatures.hasMouthPosition)
    {
        extFeatures.nosePosition = TRIANGLE_CENTROID(extFeatures.leftEyePosition,extFeatures.rightEyePosition,extFeatures.mouthPosition);
        extFeatures.hasNosePosition = true;
    }
}

@end
