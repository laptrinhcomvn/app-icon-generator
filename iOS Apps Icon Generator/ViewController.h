//
//  ViewController.h
//  iOS Apps Icon Generator
//
//  Created by Le Anh Tung on 5/15/15.
//  Copyright (c) 2015 © IML. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMLImageView+DragDrop.h"
#import "LTUtilites.h"

@interface ViewController : NSViewController<IMLImageView_DragDropDelegate> {
    NSString *outputPath;
    NSString *inputPath;
    
    NSString *outputPathAndroid;
    
    NSString *outputPathMacOS;
    
    NSDictionary *iconNamedSizes;
}

@property (weak) IBOutlet NSTextField *lbOutputPath;

@property (weak) IBOutlet IMLImageView_DragDrop *ivIcon;

@property (weak) IBOutlet NSButton *isMacOS;
@property (weak) IBOutlet NSButton *isIOS;
@property (weak) IBOutlet NSButton *isAndroid;

@property (weak) IBOutlet NSTextField *lbMessage;

- (IBAction)btnGenerateClicked:(id)sender;

@end

