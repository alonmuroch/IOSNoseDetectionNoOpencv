//
//  ExtendedCIFaceFeature.m
//  NoseDetectionNoOpencv
//
//  Created by Alon on 3/17/14.
//  Copyright (c) 2014 Alon. All rights reserved.
//

#import "ExtendedCIFaceFeature.h"

@implementation ExtendedCIFaceFeature

-(id)initWithCIFaceFeature:(CIFaceFeature*)faceFeature
{
    if ( self = [super init] )
    {
        bounds = faceFeature.bounds;
        hasFaceAngle = faceFeature.hasFaceAngle;
        faceAngle = faceFeature.faceAngle;
        hasLeftEyePosition = faceFeature.hasLeftEyePosition;
        leftEyePosition = faceFeature.leftEyePosition;
        hasRightEyePosition = faceFeature.hasRightEyePosition;
        rightEyePosition = faceFeature.rightEyePosition;
        hasMouthPosition = faceFeature.hasMouthPosition;
        mouthPosition = faceFeature.mouthPosition;
        hasSmile = faceFeature.hasSmile;
        leftEyeClosed = faceFeature.leftEyeClosed;
        rightEyeClosed = faceFeature.rightEyeClosed;
    }
    return self;
}

@end
