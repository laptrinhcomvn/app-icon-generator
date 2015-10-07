//
//  ViewController.m
//  iOS Apps Icon Generator
//
//  Created by Le Anh Tung on 5/15/15.
//  Copyright (c) 2015 © IML. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize ivIcon, lbOutputPath;
@synthesize isIOS, isAndroid;

- (void)viewDidLoad {
    [super viewDidLoad];
    ivIcon.delegate = self;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)dropComplete:(NSString *)filePath {
    NSLog(@"Drop file path: %@", filePath);
    
    inputPath = filePath;
   
    outputPathAndroid = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"AndroidIcons/src"];
    
    outputPath = [[[filePath stringByDeletingPathExtension] stringByAppendingString:@".xcassets"] stringByAppendingPathComponent:@"AppIcon.appiconset"];
    
    lbOutputPath.stringValue = [filePath stringByDeletingLastPathComponent];
}

- (IBAction)btnGenerateClicked:(id)sender {
    NSLog(@"Start convert file and save to output");
    
    if (outputPath == nil) {
        NSRunAlertPanel(@"Error", @"%@", nil, nil, nil, @"Please select icon file first!");
        
        return;
    }
    
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // iOS work
    if (isIOS.state == NSOnState) {
        // delete old one
        [fm removeItemAtPath:outputPath error:&error];
        
        // create new result dir for iOS
        if([fm createDirectoryAtPath:outputPath withIntermediateDirectories:YES attributes:nil error:&error]){
            // copy json file
            [fm copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Contents" ofType:@"json"] toPath:[outputPath stringByAppendingPathComponent:@"Contents.json"] error:&error];
            
            // read config size list
            NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"IconSize" ofType:@"plist"];
            iconNamedSizes = [NSDictionary dictionaryWithContentsOfFile:scorePath];
            
            for (NSString *named in iconNamedSizes) {
                
                [LTUtilites writeImage:[LTUtilites resizeImageWithPath:inputPath toSize:CGSizeMake(((NSNumber *)[iconNamedSizes objectForKey:named]).floatValue, ((NSNumber *)[iconNamedSizes objectForKey:named]).floatValue)] toPath:[outputPath stringByAppendingPathComponent:[named stringByAppendingPathExtension:@"png"]]];
                
            }
            
            NSRunAlertPanel(@"Success", @"Your Icon set was generated at: %@", nil, nil, nil, outputPath);
            
        } else {
            NSLog(@"Convert error: %@", error.description);
            NSRunAlertPanel(@"Error", @"%@", nil, nil, nil, @"Convert failed, please try again.");
        }
    }
    
    // Android work
    if (isAndroid.state == NSOnState) {
        // delete old one
        [fm removeItemAtPath:outputPathAndroid error:&error];
        
        // create new result dir for Android
        if([fm createDirectoryAtPath:outputPathAndroid withIntermediateDirectories:YES attributes:nil error:&error]){
            // read config size list
            NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"AndroidIconSize" ofType:@"plist"];
            iconNamedSizes = [NSDictionary dictionaryWithContentsOfFile:scorePath];
            
            NSString *tempOutPath;
            
            for (NSString *named in iconNamedSizes) {
                tempOutPath = [outputPathAndroid stringByAppendingPathComponent:[named stringByAppendingPathExtension:@"png"]];
                
                // delete old one
                [fm removeItemAtPath:tempOutPath error:&error];
                
                // create new result dir for iOS
                if([fm createDirectoryAtPath:[tempOutPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error]){
                    [LTUtilites writeImage:[LTUtilites resizeImageWithPath:inputPath toSize:CGSizeMake(((NSNumber *)[iconNamedSizes objectForKey:named]).floatValue, ((NSNumber *)[iconNamedSizes objectForKey:named]).floatValue)] toPath:tempOutPath];
                }
                
            }
            
            NSRunAlertPanel(@"Success", @"Your Icon set was generated at: %@", nil, nil, nil, outputPath);
            
        } else {
            NSLog(@"Convert error: %@", error.description);
            NSRunAlertPanel(@"Error", @"%@", nil, nil, nil, @"Convert failed, please try again.");
        }
    }
    
    NSLog(@"End convert");
}


@end
