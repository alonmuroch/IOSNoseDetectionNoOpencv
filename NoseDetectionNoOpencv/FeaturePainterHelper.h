//
//  FeaturePainterHelper.h
//  NoseDetectionNoOpencv
//
//  Created by Alon on 3/17/14.
//  Copyright (c) 2014 Alon. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <QuartzCore/QuartzCore.h>
#include "ExtendedCIFaceFeature.h"
#import "Utils.h"

@interface FeaturePainterHelper : NSObject

+ (void)drawFaceWithFeatures:(NSArray *)features :(UIImageView*)activeImageView :(UIImage*)faceImage;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(void)drawFootbalOnNose:(NSArray *)features :(UIImageView*)activeImageView :(UIImage*)faceImage;

@end
