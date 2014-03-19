//
//  AMViewController.m
//  NoseDetectionNoOpencv
//
//  Created by Alon on 3/17/14.
//  Copyright (c) 2014 Alon. All rights reserved.
//

#import "AMViewController.h"

@interface AMViewController ()

@end

@implementation AMViewController

static UIImagePickerController *cameraUI;
static UIImagePickerController *mediaUI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibNameWithScreenSize;
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568)
            nibNameWithScreenSize = [NSString stringWithFormat:@"%@[4]",nibNameOrNil];
        else
            nibNameWithScreenSize = [NSString stringWithFormat:@"%@[3.5]",nibNameOrNil];
    }
    
    self = [super initWithNibName:nibNameWithScreenSize bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.btnCamera.enabled = false;
    }
    
    /* main image view tap recognizer, hides and shows the toolbar */
    toolbarIsHidden = false;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewTapped:)];
    tap.numberOfTapsRequired = 1;
    [self.imgView addGestureRecognizer:tap];
    tap.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/******************************
            Face detection
 ******************************/
-(void)detectFaces
{
    if(!detector){
        detector = [[ExtendedCIDetector alloc] init];
        [detector detectorOfType:CIDetectorTypeFace
                                     context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Utils debugLog:@"detecting faces ..."];
        NSArray* features = [detector extendedFeaturesInImage:[[CIImage alloc] initWithImage:originalImage]];
        [Utils debugLog:[NSString stringWithFormat:@"%d Faces Found",[features count]]];
         dispatch_async(dispatch_get_main_queue(), ^{
             /* Change to 1 to print all face features, 
                0 to print only football */
            #if 0
                [FeaturePainterHelper drawFaceWithFeatures:features :self.imgView :originalImage];
            #else
                 [FeaturePainterHelper drawFootbalOnNose:features :self.imgView :originalImage];
            #endif
            [self.lblCenter setText:@"Done !"];
         });
    });
}

/******************************
        IBActions
 ******************************/
-(IBAction)btnCameraPressed:(id)sender
{
    [self  showCameraUI];
}

-(IBAction)btnGalleryPressed:(id)sender
{
    [self showMediaUI];
}

- (void)imgViewTapped:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         toolbarIsHidden = !toolbarIsHidden;
                         if(toolbarIsHidden)
                         {
                             [self.toolBar setUserInteractionEnabled:false];
                             [self.toolBar setAlpha:0.0f];

                         }
                         else
                         {
                             [self.toolBar setUserInteractionEnabled:true];
                             [self.toolBar setAlpha:1.0f];

                         }
                     }
                     completion:nil];
}

/******************************
    Camera and gallery methods
 ******************************/

- (void) showCameraUI {
    [self startCameraControllerFromViewController: self usingDelegate: self];
}

- (void) showMediaUI {
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate>) delegate {
    if(!cameraUI)
    {
        if (([UIImagePickerController isSourceTypeAvailable:
              UIImagePickerControllerSourceTypeCamera] == NO)
            || (delegate == nil)
            || (controller == nil))
            return NO;
        
        
        cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        cameraUI.allowsEditing = NO;
        cameraUI.delegate = delegate;
    }
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate>) delegate {
    if(!mediaUI)
    {
        if (([UIImagePickerController isSourceTypeAvailable:
              UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
            || (delegate == nil)
            || (controller == nil))
            return NO;
        
        mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        mediaUI.mediaTypes =
        [UIImagePickerController availableMediaTypesForSourceType:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum];

        mediaUI.allowsEditing = NO;
        
        mediaUI.delegate = delegate;
    }
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)  == kCFCompareEqualTo) {
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if(picker == cameraUI)
            UIImageWriteToSavedPhotosAlbum (originalImage, nil, nil , nil);
    }
    originalImage = [FeaturePainterHelper imageWithImage:originalImage scaledToSize:self.imgView.bounds.size];
    [self.imgView setImage:nil];
    [picker  dismissViewControllerAnimated: YES completion:nil];
    [self.lblCenter setText:@"Working ..."];
    [self detectFaces];
}

@end
