//
//  ExtendedCIDetector.h
//  NoseDetectionNoOpencv
//
//  Created by Alon on 3/17/14.
//  Copyright (c) 2014 Alon. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "ExtendedCIFaceFeature.h"

@interface ExtendedCIDetector : CIDetector
{
    CIDetector *baseCIDetector;
}

-(void)detectorOfType:(NSString *)type context:(CIContext *)context options:(NSDictionary *)options;
-(NSMutableArray *)extendedFeaturesInImage:(CIImage *)image;

@end
