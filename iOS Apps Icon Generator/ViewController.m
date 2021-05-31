//
//  ViewController.m
//  iOS Apps Icon Generator
//
//  Created by Le Anh Tung on 5/15/15.
//  Copyright (c) 2015 © IML. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize ivIcon, lbOutputPath, lbMessage;
@synthesize isIOS, isAndroid, isMacOS;

- (void)viewDidLoad {
    [super viewDidLoad];
    ivIcon.delegate = self;
    
    lbMessage.hidden = true;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)dropComplete:(NSString *)filePath {
    NSLog(@"Drop file path: %@", filePath);
    
    inputPath = filePath;
   
    outputPathAndroid = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"iml_generated_output/android/app/src/main/res"];
    
    outputPath = [[[[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"iml_generated_output/ios"] stringByAppendingString:@".xcassets"] stringByAppendingPathComponent:@"AppIcon.appiconset"];
    
    outputPathMacOS = [[[[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"iml_generated_output/macOS"] stringByAppendingString:@".xcassets"] stringByAppendingPathComponent:@"AppIcon.appiconset"];
    
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
    
    // macOS work
    if (isMacOS.state == NSOnState) {
        // delete old one
        [fm removeItemAtPath:outputPathMacOS error:&error];
        
        // create new result dir for iOS
        if([fm createDirectoryAtPath:outputPathMacOS withIntermediateDirectories:YES attributes:nil error:&error]){
            // make macOS json file
            [self makeContentJsonForMacOS:fm withIconSizeFile:@"macOSIconSize.plist" outputPath:outputPathMacOS];
            
            
            //NSRunAlertPanel(@"Success", @"Your Icon set was generated at: %@", nil, nil, nil, outputPath);
            [self showMessage:@"Success" forError:false];
        } else {
            //NSLog(@"Convert error: %@", error.description);
            //NSRunAlertPanel(@"Error", @"%@", nil, nil, nil, @"Convert failed, please try again.");
            [self showMessage:@"Failed" forError:true];
        }
    }
    
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
            
            //NSRunAlertPanel(@"Success", @"Your Icon set was generated at: %@", nil, nil, nil, outputPath);
            [self showMessage:@"Success" forError:false];
        } else {
            //NSLog(@"Convert error: %@", error.description);
            //NSRunAlertPanel(@"Error", @"%@", nil, nil, nil, @"Convert failed, please try again.");
            [self showMessage:@"Failed" forError:true];
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
            
            //NSRunAlertPanel(@"Success", @"Your Icon set was generated at: %@", nil, nil, nil, outputPath);
            [self showMessage:@"Success" forError:false];
            
        } else {
            //NSLog(@"Convert error: %@", error.description);
            //NSRunAlertPanel(@"Error", @"%@", nil, nil, nil, @"Convert failed, please try again.");
            [self showMessage:@"Failed" forError:true];
        }
    }
    
    //NSLog(@"End convert");
}


- (void)showMessage:(NSString *)msg forError:(Boolean)isError {
    lbMessage.textColor = (isError ? NSColor.redColor : NSColor.blueColor);
    
    lbMessage.stringValue = msg;
    
    lbMessage.hidden = false;
}

- (void)makeContentJsonForMacOS:(NSFileManager *)fm withIconSizeFile:(NSString *)plistFileName outputPath:(NSString *)outPath {
    NSError *error = nil;
    NSString *originJsonPath = [[NSBundle mainBundle] pathForResource:@"macOS_Contents" ofType:@"json"];
    [fm copyItemAtPath:originJsonPath toPath:[outPath stringByAppendingPathComponent:@"Contents.json"] error:&error];
    NSData *originData = [NSData dataWithContentsOfFile:originJsonPath];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:originData options:NSJSONReadingAllowFragments error:&error];
    if ([jsonObject isKindOfClass:[NSDictionary class]] == NO) return;
    NSDictionary *dict = (NSDictionary *)jsonObject;
    // read config size list
    NSString *scorePath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:nil];
    iconNamedSizes = [dict objectForKey:@"images"];
    NSString *sizeA,*sizeB,*scale;
    NSString *sizeStr = nil;
    NSArray *sizeArray = nil;
    NSString *named;
    for (NSDictionary *item in iconNamedSizes) {
        sizeStr = [item objectForKey:@"size"];
        sizeArray = [sizeStr componentsSeparatedByString:@"x"];
        sizeA = sizeArray.firstObject;
        sizeB = sizeArray.lastObject;
        named = [item objectForKey:@"filename"];
        scale = [[item objectForKey:@"scale"] stringByReplacingOccurrencesOfString:@"x" withString:@""];
        double sizeWidth = sizeA.doubleValue * scale.doubleValue;
        double sizeHeight = sizeB.doubleValue * scale.doubleValue;
        [LTUtilites writeImage:[LTUtilites resizeImageWithPath:inputPath toSize:CGSizeMake(sizeWidth,sizeHeight)] toPath:[outPath stringByAppendingPathComponent:named]];
    }
}

@end
