//
//  FeaturePainterHelper.m
//  NoseDetectionNoOpencv
//
//  Created by Alon on 3/17/14.
//  Copyright (c) 2014 Alon. All rights reserved.
//

#import "FeaturePainterHelper.h"

@implementation FeaturePainterHelper

+(void)drawFootbalOnNose:(NSArray *)features :(UIImageView*)activeImageView :(UIImage*)faceImage
{
    UIGraphicsBeginImageContextWithOptions(faceImage.size, NO,0.0f);
    [faceImage drawInRect:activeImageView.bounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, activeImageView.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (scale > 1.0) {
        // For retina displays
        CGContextScaleCTM(context, 0.5, 0.5);
    }
    
    for (ExtendedCIFaceFeature *feature in features)
    {
        if(feature.hasNosePosition)
        {
            CGFloat faceRectMaxSize = MAX(feature.bounds.size.width, feature.bounds.size.height);
            CGFloat radius = (MIN(faceRectMaxSize/4,40) * [UIScreen mainScreen].scale)/2;
            UIImage *footballImage = [UIImage imageNamed:@"football"];
            [footballImage drawInRect:CGRectMake(feature.nosePosition.x -radius,
                                                 feature.nosePosition.y - radius,
                                                 radius*2, radius*2)];
        }
    }
    activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

+ (void)drawFaceWithFeatures:(NSArray *)features :(UIImageView*)activeImageView :(UIImage*)faceImage
{
    UIGraphicsBeginImageContextWithOptions(faceImage.size, NO,0.0f);
    [faceImage drawInRect:activeImageView.bounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, activeImageView.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (scale > 1.0) {
        // For retina displays
        CGContextScaleCTM(context, 0.5, 0.5);
    }
    
    for (ExtendedCIFaceFeature *feature in features)
    {
        [Utils debugLog:[NSString stringWithFormat:@"face frame %f,%f",feature.bounds.origin.x,feature.bounds.origin.y]];
        
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 2.0f * scale);
        CGContextAddRect(context, feature.bounds);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        // Set red feature color
        CGContextSetRGBFillColor(context, 1.0f, 0.0f, 0.0f, 0.4f);
        
        if (feature.hasLeftEyePosition) {
            [self drawFeatureInContext:context atPoint:feature.leftEyePosition inFaceRect:feature.bounds];
        }
        
        if (feature.hasRightEyePosition) {
            [self drawFeatureInContext:context atPoint:feature.rightEyePosition inFaceRect:feature.bounds];
        }
        
        if (feature.hasMouthPosition) {
            [self drawFeatureInContext:context atPoint:feature.mouthPosition inFaceRect:feature.bounds];
        }
        
        if (feature.hasNosePosition) {
            [self drawFeatureInContext:context atPoint:feature.nosePosition inFaceRect:feature.bounds];
        }
    }
    
    activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}

+ (void)drawFeatureInContext:(CGContextRef)context atPoint:(CGPoint)featurePoint inFaceRect:(CGRect)faceRect{
    CGFloat faceRectMaxSize = MAX(faceRect.size.width, faceRect.size.height);
    CGFloat radius = MIN(faceRectMaxSize/16,20) * [UIScreen mainScreen].scale;
    CGContextAddArc(context, featurePoint.x, featurePoint.y, radius, 0, M_PI * 2, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
