//
//  ExtendedCIFaceFeature.h
//  NoseDetectionNoOpencv
//
//  Created by Alon on 3/17/14.
//  Copyright (c) 2014 Alon. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface ExtendedCIFaceFeature : CIFaceFeature
{
}

@property(assign) BOOL hasNosePosition;
@property(assign) CGPoint nosePosition;

-(id)initWithCIFaceFeature:(CIFaceFeature*)faceFeature;

@end
