//
//  AMViewController.h
//  NoseDetectionNoOpencv
//
//  Created by Alon on 3/17/14.
//  Copyright (c) 2014 Alon. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ExtendedCIDetector.h"
#import "FeaturePainterHelper.h"
#import "Utils.h"

@interface AMViewController : UIViewController <UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>
{
    UIImage *originalImage;
    
    bool toolbarIsHidden;
    
    ExtendedCIDetector *detector;
}


/* IBOutlets */
@property(nonatomic) IBOutlet UIBarButtonItem *btnCamera;
@property(nonatomic) IBOutlet UIBarButtonItem *btnGallery;
@property(nonatomic) IBOutlet UILabel *lblCenter;
@property(nonatomic) IBOutlet UIImageView *imgView;
@property(nonatomic) IBOutlet UIToolbar *toolBar;

/* IBActions */
-(IBAction)btnCameraPressed:(id)sender;
-(IBAction)btnGalleryPressed:(id)sender;

@end
